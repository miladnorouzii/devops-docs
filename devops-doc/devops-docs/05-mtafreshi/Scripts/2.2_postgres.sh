#!/bin/bash

configure_postgresql ()
{
    path=/etc/postgresql/16/main
    tail -n 2 file > slave
    slavehost=`head -n 1 file | awk '{print $1}'`
    masterhost=`tail -n 1 file | awk '{print $1}'`
    ip a | grep ${slavehost} | awk '{print $2}' | cut -d / -f 2 > prefix
    i=$slavehost
    s=`ifconfig | grep ${slavehost} | awk '{print $4}'`
    IFS=. read -r i1 i2 i3 i4 <<< "$i"
    IFS=. read -r m1 m2 m3 m4 <<< "$s"
    ip=`printf "%d.%d.%d.%d\n" $i1 $i2 $i3 $i4`
    mask=`printf "%d.%d.%d.%d\n" $m1 $m2 $m3 $m4`
    id=`printf "%d.%d.%d.%d\n" "$((i1 & m1))" "$((i2 & m2))" "$((i3 & m3))" "$((i4 & m4))"`
    sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '${slavehost}'/g" ${path}/postgresql.conf
    sleep 2
	sudo echo "host    all          postgres         ${id}/`cat prefix`                md5" >> ${path}/pg_hba.conf
    sleep 2
    sudo -u postgres psql -c "ALTER USER postgres PASSWORD '123456';"
	sleep 2
    sudo -u postgres createdb gitlabhq_production;
	sleep 2
    sudo systemctl restart postgresql
    sleep 2
    echo `ss -ntlp | grep 5432`
    echo "your IP Address and Port are Listening. "
    echo ""
    echo "****** ATTENTION ******"
    echo "_______________________"
    echo ""
    echo "RUN gitlab-ctl reconfigure in GitLab Server for Configuring DataBase.!~ "
    echo ""
    sleep 10
    echo "Run this Command for show 'root' Username 'Password' in GitLab Server.!~ "
    sleep 3
    echo ""
    echo "cat /etc/gitlab/initial_root_password | grep Password:"
    sleep 5
}

install_postgresql ()
{
    echo "The Postgresql Install is Starting... "
    sudo apt update
    sudo apt install -y postgresql postgresql-client libpq-dev postgresql-contrib net-tools
    sleep 2
	  psql --version
    sleep 2
}

check_postgresql ()
{
    systemctl restart postgresql
    if [ `echo $?` == 0 ]; then
	      echo "The Postgresql Server is already Installed in your System. "
        configure_postgresql
        sleep 5
    else
        echo "The Postgresql Server is NOT Installed in your System. "
        install_postgresql
        sleep 2
        configure_postgresql
        sleep 5
    fi
}

check_root ()
{
    if [ `whoami` == "root" ]; then
        echo "you are login with Root User"
    else
        echo "Please Login "root" User and Run Script Agein." 
        exit 1
    fi
}

internet_connection()
{
    ping -c 2 8.8.8.8
    if [ `echo $?` == 0 ]; then
        echo "Internet Connection is Established. "
    else
        echo "NO Internet Connection. "
    fi
}

recommended ()
{
    echo "*** Recommended: ***"
    echo "____________________"
    echo ""
    echo "You have to create LVM in youe Machine and after that try to install Posgresql"
}

detect_os ()
{
  if [[ ( -z "${os}" ) && ( -z "${dist}" ) ]]; then
    # some systems dont have lsb-release yet have the lsb_release binary and
    # vice-versa
    if [ -e /etc/lsb-release ]; then
      . /etc/lsb-release

      if [ "${ID}" = "raspbian" ]; then
        os=${ID}
        dist=`cut --delimiter='.' -f1 /etc/debian_version`
      else
        os=${DISTRIB_ID}
        dist=${DISTRIB_CODENAME}

        if [ -z "$dist" ]; then
          dist=${DISTRIB_RELEASE}
        fi
      fi

    elif [ `which lsb_release 2>/dev/null` ]; then
      dist=`lsb_release -c | cut -f2`
      os=`lsb_release -i | cut -f2 | awk '{ print tolower($1) }'`

    elif [ -e /etc/debian_version ]; then
      # some Debians have jessie/sid in their /etc/debian_version
      # while others have '6.0.7'
      os=`cat /etc/issue | head -1 | awk '{ print tolower($1) }'`
      if grep -q '/' /etc/debian_version; then
        dist=`cut --delimiter='/' -f1 /etc/debian_version`
      else
        dist=`cut --delimiter='.' -f1 /etc/debian_version`
      fi

    else
      unknown_os
    fi
  fi

  if [ -z "$dist" ]; then
    unknown_os
  fi
}

main ()
{
    check_root
    internet_connection
    detect_os
    if [ ${os} == Ubuntu ]; then
        recommended
        sleep 2
        check_postgresql
    else
        echo "can not Install Script in this Version Operation. "
    fi
}
main