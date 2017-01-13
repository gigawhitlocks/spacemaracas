# from guacamole/guacamole:latest

from tomcat:jre8
run apt-get -yq update && apt-get -yq upgrade
run apt-get install -yq openjdk-8-jdk-headless maven git
run git clone git://github.com/apache/incubator-guacamole-client.git
workdir incubator-guacamole-client
run mvn package &&\
  mv guacamole/target/guacamole-0.9.11-incubating.war /usr/local/tomcat/webapps/guacamole.war


env GUACAMOLE_HOME=/root/.guacamole
run mkdir -p /root/.guacamole/extensions &&\
  mv ./extensions/guacamole-auth-noauth/target/guacamole-auth-noauth-0.9.11-incubating.jar /root/.guacamole/extensions
add noauth-config.xml /root/.guacamole/noauth-config.xml
add logback.xml /root/.guacamole/logback.xml
run echo "noauth-config: /root/.guacamole/noauth-config.xml" >> /root/.guacamole/guacamole.properties

add start.sh .
cmd /bin/bash ./start.sh
