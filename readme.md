Se desarrolló un ambiente de pruebas con 4 nodos Wildfly 26.1.1Final/JDK17 + 1 nodo Alpine FTP, como infraestructura de testing para nuestros proyectos con Java EE y Wildfly.
Post: https://filenotfound.com.uy/2022/07/nuestro-ambiente-de-testing-con-docker-y-wildfly/
Este ambiente de pruebas sigue el siguiente esquema:
![Diagrama de infraestructura](AmbientePruebas.png)
A los 4 nodos Wildfly se les agrega 1 nodo FTP con Alpine, con el fin de centralizar el acceso a ficheros de todos los nodos Wildfly.
Esto se logró con una estructura de montajes entre el equipo anfitrión, el nodo FTP y los 4 nodos Wildfly.
Si accedemos al nodo FTP desde filezilla tendremos acceso a las 4 carpetas de deployment de Wildfly y los 4 ficheros standalone.xml


¿Por qué un ambiente de pruebas dockerizado?
Proporciona muchas ventajas con respecto a las máquinas virtuales en virtualbox y al ambiente de integración porque:
•	Permite mayor portabilidad
•	Las imágenes de los contenedores son mucho más livianas (ej.: una distribución Alpine con Wildfly 26 y JDK17 instalado pesa aprox 800mb).
•	Son mucho más simples de implementar en otros equipos que un conjunto de máquinas virtuales.
•	Si automatizamos el despliegue de este ambiente de pruebas, podemos tener en nuestro equipo de trabajo un ambiente de testing unificado.
•	Podemos armar una subred de nodos con una ip asignada a cada uno, que está aislada del host, a excepción de los puertos que podamos mapear para ser accedidos por el anfitrión.
