#!/bin/bash

guacd_port=4822
guacd_hostname=guacd.maracas

echo "guacd-hostname: $guacd_hostname" >> $GUACAMOLE_HOME/guacamole.properties
echo "guacd-port: $guacd_port" >> $GUACAMOLE_HOME/guacamole.properties

# do we need to export these variables?
export GUACD_HOSTNAME=$guacd_hostname
export GUACD_PORT=$guacd_port

catalina.sh run
)
