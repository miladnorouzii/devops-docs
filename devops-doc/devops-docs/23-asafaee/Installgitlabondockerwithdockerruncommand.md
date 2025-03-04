docker pull gitlab/gitlab-ce:latest

docker run --detach \
  --hostname gitlab.example.com \
  --publish 443:443 --publish 80:80 --publish 22:22 \
  --name gitlab \
  --restart always \
  --volume /srv/gitlab/config:/etc/gitlab \
  --volume /srv/gitlab/data:/var/opt/gitlab \
  --volume /srv/gitlab/logs:/var/log/gitlab \
  gitlab/gitlab-ce:latest

docker exec -it gitlab cat /etc/gitlab/initial_root_password
