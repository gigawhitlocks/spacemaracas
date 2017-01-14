from gigawhitlocks/guacamole:latest
run mkdir -p /root/.guacamole/extensions &&\
  mv ./extensions/guacamole-auth-noauth/target/guacamole-auth-noauth-0.9.11-incubating.jar /root/.guacamole/extensions
add noauth-config.xml /root/.guacamole/noauth-config.xml
add logback.xml /root/.guacamole/logback.xml
run echo "noauth-config: /root/.guacamole/noauth-config.xml" >> /root/.guacamole/guacamole.properties

cmd /bin/bash ./start.sh
