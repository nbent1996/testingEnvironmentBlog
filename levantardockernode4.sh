#!/bin/sh
sh /opt/jboss/wildfly/bin/standalone.sh --server-config="standalone-full-ha.xml" -Djboss.node.name=dockernode4 -b "192.168.10.5" -bmanagement "192.168.10.5" -Djboss.socket.binding.port-offset=307