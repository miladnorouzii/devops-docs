#!/bin/bash

version=16
path=/etc/postgresql/${version}/main
hosts=/etc/hosts
file=./file
postgres=./postgres.sh
rpath=/var/lib/postgresql/${version}

read_m_s ()
{
    read -p "Enter Master Server IP Address: " master
    read -p "Enter Master Server Host Name: " masterhost
    read -p "Enter Slave Server IP Address: " slave
    read -p "Enter slave Server Host Name: " slavehost
}

input ()
{
    echo ${master} ${masterhost} >> ${hosts}
    echo ${slave} ${slavehost} >> ${hosts}
    echo ${slave} ${slavehost} >> ${file}
    echo ${master} ${masterhost} >> ${file}
}

cat ()
{
    sudo -- sh -c "cat file >> /etc/hosts"
}

check_root ()
{
    if [ `whoami` == "root" ]; then
        echo "you are login with Root User"
    else
        echo "Please Login "root" User and Run Script Agein." 
    fi
}

install_postgresql ()
{
    echo "The Postgresql Install is Starting... "
    sleep 2
    sudo apt update
    sudo apt install postgresql postgresql-contrib postgresql-client -y
}

master_configuration ()
{
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = "${masterhost}"/g" ${path}/postgresql.conf
    echo "Please Enter Password for Complete Create User."
    sleep 5
    sudo -u postgres createuser --replication -P replica
    send 'Xx@123456'
    send 'Xx@123456'
    echo "host    replication     replica         "${slavehost}"                md5" >> ${path}/pg_hba.conf
    sudo systemctl restart postgresql
}

slave_configuration ()
{
    version=16
    rpath=/var/lib/postgresql/${version}
    masterhost=$(sudo tail -n 1 /etc/hosts | awk '{print $2}')
    sudo systemctl stop postgresql
    sudo -u postgres cp -R ${rpath}/main ${rpath}/main_old/
    sudo rm -rf ${rpath}/main
    sudo -u postgres pg_basebackup -h ${masterhost} -D ${rpath}/main/ -U replica -P -v -R -X stream -C -S slaveslot1
    send 'Xx@123456'
    send 'Xx@123456'
    sleep 30
    sudo systemctl start postgresql
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

  # remove whitespace from OS and dist name
  os="${os// /}"
  dist="${dist// /}"

  echo "Detected operating system as $os."
}

ssh_keygen ()
{
    read -p "Enter Slave Server Username: " name
    ssh-keygen
    ssh-copy-id ${name}@${slavehost}
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

main ()
{
    detect_os
    if [ ${os} == Ubuntu ]; then
        internet_connection
        read_m_s
        input
        sleep 2
        echo "*** Recommended: ***"
        echo "____________________"
        echo "You have to create LVM in youe Machine and after that try to install Posgresql"
        sleep 5
        install_postgresql
        sleep 2
        echo "Install Postgresql Completed. "
        master_configuration
        echo "Configuration Completed. "
        sleep 2
        ssh_keygen
        rsync ${file} ${name}@${slavehost}:/home/${name}
        rsync ${postgres} ${name}@${slavehost}:/home/${name}
        ssh -T -t ${name}@${slavehost} <<EOF
        sleep 2
        $(declare -f cat)
        cat
        sleep 2
        $(declare -f detect_os)
        detect_os
        if [ ${os} == Ubuntu ]; then
            echo " Install Script in this Version Operation. "
        else
            echo "can not Install Script in this Version Operation. "
        fi
        sleep 1
        $(declare -f internet_connection)
        internet_connection
        sleep 2
        echo "*** Recommended: ***"
        echo "____________________"
        echo "You have to create LVM in youe Machine and after that try to install Posgresql"
        sleep 5
        $(declare -f install_postgresql)
        install_postgresql
        sleep 2
        echo "Install Postgresql Completed. "
        $(declare -f slave_configuration)
        slave_configuration
        echo "Configuration Completed. "
        echo "Done!~ . "
        sleep 5
EOF
    else
        echo "can not Install Script in this Version Operation. "
    fi
}

main