# Kcptube-Docker
Auto make kcptube docker.Every weekend check kcptube update then build docker push to docker hub.

## Original:
https://github.com/cnbatch/kcptube

## How to run
``
docker run -d \

--network host \

--name kcptube \

-v /root/test/kcptube.conf:/root/kcptube/kcptube.conf \

-e TZ=Asia/Shanghai \

zhouyut001/kcptube-docker
``