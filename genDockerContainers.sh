#!/bin/sh
echo  Generacion de contenedores
docker login

docker pull eclipse-temurin:17-jdk-alpine

echo Eliminar todas las imagenes, contenedores, volumenes y redes de docker
docker volume prune --force
docker container prune --force
docker image prune --force
docker system prune -a --force

echo Generar imagenes con los dockerfile brindados

docker build --no-cache -f dockerfile-WILDFLY . -t alpine3.14wildfly26.1.1jdk17:1.0  
docker build --no-cache -f dockerfile-VSFTPD-ALPINE . -t vsftpdalpine3.15:1.0 

echo Crear subred de contenedores en el rango 192.168.10.0/24
docker network create testNetwork --driver bridge --subnet 192.168.10.0/24

echo Permisos a los scripts que se van a montar
chmod +x levantardockernode1.sh levantardockernode2.sh levantardockernode3.sh levantardockernode4.sh

echo Ejecutar contenedor con servicio FTP-alpine
docker run --rm -d --network testNetwork --ip 192.168.10.6 -p 8021:8021 -p 21000-21010:21000-21010 -v /home/testingEnvironment:/home/testingEnvironment -e USERS="ftpNode|ftp1234" -e ADDRESS="192.168.0.100" vsftpdalpine3.15:1.0
echo Ejecutar contenedores Wildfly
docker run -itd --network testNetwork --ip 192.168.10.2 -v c:/testingEnvironmentBlog/standalone-full-ha-dockernode1.xml:/opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml -v c:/testingEnvironmentBlog/levantardockernode1.sh:/opt/jboss/wildfly/levantarWildfly.sh -v c:/testingEnvironmentBlog/cacerts:/opt/java/openjdk/lib/security/cacerts -v c:/testingEnvironmentBlog/deploymentDockerNode1:/opt/jboss/wildfly/standalone/deployments --publish 8087:8087 --publish 9997:9997 -d alpine3.14wildfly26.1.1jdk17:1.0 
docker run -itd --network testNetwork --ip 192.168.10.3 -v c:/testingEnvironmentBlog/standalone-full-ha-dockernode2.xml:/opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml -v c:/testingEnvironmentBlog/levantardockernode2.sh:/opt/jboss/wildfly/levantarWildfly.sh -v c:/testingEnvironmentBlog/cacerts:/opt/java/openjdk/lib/security/cacerts -v c:/testingEnvironmentBlog/deploymentDockerNode2:/opt/jboss/wildfly/standalone/deployments --publish 8187:8187 --publish 10097:10097 -d alpine3.14wildfly26.1.1jdk17:1.0 
docker run -itd --network testNetwork --ip 192.168.10.4 -v c:/testingEnvironmentBlog/standalone-full-ha-dockernode3.xml:/opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml -v c:/testingEnvironmentBlog/levantardockernode3.sh:/opt/jboss/wildfly/levantarWildfly.sh -v c:/testingEnvironmentBlog/cacerts:/opt/java/openjdk/lib/security/cacerts -v c:/testingEnvironmentBlog/deploymentDockerNode3:/opt/jboss/wildfly/standalone/deployments --publish 8287:8287 --publish 10197:10197 -d alpine3.14wildfly26.1.1jdk17:1.0 
docker run -itd --network testNetwork --ip 192.168.10.5 -v c:/testingEnvironmentBlog/standalone-full-ha-dockernode4.xml:/opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml -v c:/testingEnvironmentBlog/levantardockernode4.sh:/opt/jboss/wildfly/levantarWildfly.sh -v c:/testingEnvironmentBlog/cacerts:/opt/java/openjdk/lib/security/cacerts -v c:/testingEnvironmentBlog/deploymentDockerNode4:/opt/jboss/wildfly/standalone/deployments --publish 8387:8387 --publish 10297:10297 -d alpine3.14wildfly26.1.1jdk17:1.0 