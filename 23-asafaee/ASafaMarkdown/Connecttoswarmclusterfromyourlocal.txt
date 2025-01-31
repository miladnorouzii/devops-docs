docker --version

ssh user@manager-node-ip

docker context create swarm-context --docker "host=ssh://user@manager-node-ip"

docker context use swarm-context

docker node ls

docker service create --name my-nginx --publish 80:80 nginx

docker service ls

docker service ps my-nginx

docker swarm leave --force

