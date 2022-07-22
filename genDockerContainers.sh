#!/bin/sh
echo  Generacion de contenedores

echo Permisos a los ficheros montados
echo Generacion de usuario
groupadd testingGroup
useradd userTest -m -g testingGroup
echo 'userTest ALL=(ALL:ALL) ALL' >> /etc/sudoers
su userTest
chown -R userTest /home/testingEnvironmentBlog
chmod g+rwx -R /home/testingEnvironmentBlog


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


echo Ejecutar contenedor con servicio FTP-alpine
docker run --rm -d --name ftpNode --network testNetwork --ip 192.168.10.6 -p 8021:8021 -p 21000-21010:21000-21010 -v /mnt/c/testingEnvironmentBlog:/home/testingEnvironmentBlog -e USERS="userTest|ftp1234|/home/testingEnvironment|1000" -e ADDRESS="192.168.0.100" vsftpdalpine3.15:1.0
echo Ejecutar contenedores Wildfly
docker run -itd --rm --name dockerNode1 --network testNetwork --ip 192.168.10.2 -v /mnt/c/testingEnvironmentBlog/standalone-full-ha-dockernode1.xml:/opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml -v /mnt/c/testingEnvironmentBlog/levantardockernode1.sh:/opt/jboss/wildfly/levantarWildfly.sh -v /mnt/c/testingEnvironmentBlog/cacerts:/opt/java/openjdk/lib/security/cacerts -v /mnt/c/testingEnvironmentBlog/deploymentDockerNode1:/opt/jboss/wildfly/standalone/deployments --publish 8087:8087 --publish 9997:9997 -d alpine3.14wildfly26.1.1jdk17:1.0 
docker run -itd --rm --name dockerNode2 --network testNetwork --ip 192.168.10.3 -v /mnt/c/testingEnvironmentBlog/standalone-full-ha-dockernode2.xml:/opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml -v /mnt/c/testingEnvironmentBlog/levantardockernode2.sh:/opt/jboss/wildfly/levantarWildfly.sh -v /mnt/c/testingEnvironmentBlog/cacerts:/opt/java/openjdk/lib/security/cacerts -v /mnt/c/testingEnvironmentBlog/deploymentDockerNode2:/opt/jboss/wildfly/standalone/deployments --publish 8187:8187 --publish 10097:10097 -d alpine3.14wildfly26.1.1jdk17:1.0 
docker run -itd --rm --name dockerNode3 --network testNetwork --ip 192.168.10.4 -v /mnt/c/testingEnvironmentBlog/standalone-full-ha-dockernode3.xml:/opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml -v /mnt/c/testingEnvironmentBlog/levantardockernode3.sh:/opt/jboss/wildfly/levantarWildfly.sh -v /mnt/c/testingEnvironmentBlog/cacerts:/opt/java/openjdk/lib/security/cacerts -v /mnt/c/testingEnvironmentBlog/deploymentDockerNode3:/opt/jboss/wildfly/standalone/deployments --publish 8287:8287 --publish 10197:10197 -d alpine3.14wildfly26.1.1jdk17:1.0 
docker run -itd --rm --name dockerNode4 --network testNetwork --ip 192.168.10.5 -v /mnt/c/testingEnvironmentBlog/standalone-full-ha-dockernode4.xml:/opt/jboss/wildfly/standalone/configuration/standalone-full-ha.xml -v /mnt/c/testingEnvironmentBlog/levantardockernode4.sh:/opt/jboss/wildfly/levantarWildfly.sh -v /mnt/c/testingEnvironmentBlog/cacerts:/opt/java/openjdk/lib/security/cacerts -v /mnt/c/testingEnvironmentBlog/deploymentDockerNode4:/opt/jboss/wildfly/standalone/deployments --publish 8387:8387 --publish 10297:10297 -d alpine3.14wildfly26.1.1jdk17:1.0 
