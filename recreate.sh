docker swarm leave --force
docker swarm init
docker network create --scope=swarm --driver=bridge --attachable  --subnet=172.22.0.0/16 --gateway=172.22.0.1 landing1
#docker network create --scope=swarm --driver=overlay --attachable  --subnet=172.23.0.0/16 --gateway=172.23.0.1 pg-cluster_local-landing
#docker stack deploy --compose-file=docker-compose.yml --with-registry-auth pg-cluster --prune
docker stack deploy -c <(docker-compose config) --resolve-image=never --with-registry-auth --prune pg-cluster
