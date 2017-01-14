from tomcat:jre8
run apt-get -yq update && apt-get -yq upgrade
run apt-get install -yq openjdk-8-jdk-headless maven git
run git clone git://github.com/apache/incubator-guacamole-client.git
workdir incubator-guacamole-client
run mvn package &&\
  mv guacamole/target/guacamole-0.9.11-incubating.war /usr/local/tomcat/webapps/guacamole.war
env GUACAMOLE_HOME=/root/.guacamole

add start.sh .
cmd /bin/bash ./start.sh
