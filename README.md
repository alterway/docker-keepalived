# DOCKER KEEPALIVED

Keepalived manage virtual ip between servers.
Containers health can be checked to keep the virtual ip on the node.

## Pre-requisites

Kernel module : ip_vs on the nodes - `modprobe ip_vs`

## Available Versions

- 1.2 (docker tags: `1.2`, `latest`) : works only on docker host debian jessie and ubuntu trusty
- 1.2-dockerinside (docker tags: `1.2-dockerinside-1.10`, `1.2-dockerinside-1.11`)

## Environment variables

- `VIRTUAL_IP`:          VIP, by default 192.168.254.254/32
- `VIRTUAL_ROUTER_ID`:   must be the same in all nodes
- `INTERFACE`:           interface to set virtual IP
- `PRIORITY`:            101 on master, 100 on backups
- `PASSWORD`:            Need the same on all nodes
- `CONTAINERS_TO_CHECK`: containers name list to check health, separated by single space
- `CHECK_FALL`:          require X failures for KO
- `CHECK_RISE`:          require X successes for OK
- `CHECK_CREATION`:      if true, please define the $SWARM_ADDR, $SWARM_CERTS and  $CHECK_HEALTH_IMAGE
- `CHECK_HEALTH_IMAGE`:  if $CHECK_CREATION, image to use to create a container every $CHECK_INTERVAL
- `SWARM_ADDR`:          default to 127.0.0.1:4000
- `SWARM_CERTS`:         The path to Swarm certificats (ca.pem, cert.pem, key.pem), by default /root/.docker/
- `CHECK_INTERVAL`:      Check health of $CONTAINERS_TO_CHECK,$CHECK_CREATION) every $CHECK_INTERVAL seconds, by default 5s
- `ENABLE_LB`:           Enable Load balancer config, if true, please define $REAL_IP, $REAL_PORTS, $LB_ALGO and $LB_KIND
- `VIRTUAL_IP_LB`:       IP for LB; This IP will be shared by all the nodes, by default 192.168.254.253/32
- `REAL_IP`:             Real address of the Backend Nodes separated by single space
- `REAL_PORTS`:          Real ports exposed on hosts separated by single space to LoadBalancing
- `LB_ALGO`:             LoadBalancing Algotythm
- `LB_KIND`:             LoadBalancing Method

## Usage

### Without docker inside
```bash
docker run -d --name keepalived --restart=always --net=host --cap-add=NET_ADMIN \
    -e VIRTUAL_IP='1.1.1.1' \
    -e VIRTUAL_ROUTER_ID='51' \
    -e INTERFACE='eth0' \
    -e PRIORITY='100' \
    -e PASSWORD=topsecret \
    -e CONTAINERS_TO_CHECK="container_name_1 container_name_2" \
    -e CHECK_FALL='1' \
    -e CHECK_RISE='1' \
    -e CHECK_CREATION='true' \
    -e CHECK_HEALTH_IMAGE='alpine' \
    -e SWARM_ADDR='127.0.0.1:4000' \
    -e SWARM_CERTS='/root/.docker/' \
    -e CHECK_INTERVAL='7' \
    -e ENABLE_LB='true' \
    -e VIRTUAL_IP_LB='1.1.1.2' \
    -e REAL_IP="1.1.1.30 1.1.1.31 1.1.1.32" \
    -e REAL_PORTS='80 443' \
    -e LB_ALGO='lblcr' \
    -e LB_KIND='DR' \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/bin/docker:/usr/bin/docker \
    -v /usr/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/:ro \
    -v /lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu \
    -v /root/.docker:/root/.docker \
    alterway/keepalived:1.2
```

### With docker inside
```bash
docker run -d --name keepalived --restart=always --net=host --cap-add=NET_ADMIN \
    -e VIRTUAL_IP='1.1.1.1' \
    -e VIRTUAL_ROUTER_ID='51' \
    -e INTERFACE='eth0' \
    -e PRIORITY='100' \
    -e PASSWORD=topsecret \
    -e CONTAINERS_TO_CHECK="container_name_1 container_name_2" \
    -e CHECK_FALL='1' \
    -e CHECK_RISE='1' \
    -e CHECK_CREATION='true' \
    -e CHECK_HEALTH_IMAGE='alpine' \
    -e SWARM_ADDR='127.0.0.1:4000' \
    -e SWARM_CERTS='/root/.docker/' \
    -e CHECK_INTERVAL='7' \
    -e ENABLE_LB='true' \
    -e VIRTUAL_IP_LB='1.1.1.2' \
    -e REAL_IP="1.1.1.30 1.1.1.31 1.1.1.32" \
    -e REAL_PORTS='80 443' \
    -e LB_ALGO='lblcr' \
    -e LB_KIND='DR' \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /root/.docker:/root/.docker \
    alterway/keepalived:1.2
```

## Contributors

- [Nicolas Berthe](https://github.com/4devnull)
- [Ophélie Mauger](https://github.com/omauger)

## License

View [LICENSE](LICENSE) for the software contained in this image.
