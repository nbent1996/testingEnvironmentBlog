#!/bin/sh
echo  Generacion de contenedores

docker login 

echo Eliminar todas las imagenes, contenedores, volumenes y redes de docker
docker stop dockerNode1 dockerNode2 dockerNode3 dockerNode4
docker rm dockerNode1 dockerNode2 dockerNode3 dockerNode4
docker volume prune --force
docker container prune --force
docker image prune --force
docker system prune -a --force

docker pull eclipse-temurin:17-jdk-alpine
docker pull delfer/alpine-ftp-server

#Se hace esto por ser un ambiente de pruebas, no recomendado para entornos de produccion
chmod 777 -R c:/testingEnvironmentBlog

echo Generar imagenes con los dockerfile brindados

docker build --no-cache -f dockerfile-WILDFLY . -t alpine3.14wildfly26.1.1jdk17:1.0  
docker build --no-cache -f dockerfile-VSFTPD-ALPINE . -t vsftpdalpine3.15:1.0 

echo Crear subred de contenedores en el rango 192.168.10.0/24
docker network create testNetwork --driver bridge --subnet 192.168.10.0/24

sh runDockerContainers.sh
