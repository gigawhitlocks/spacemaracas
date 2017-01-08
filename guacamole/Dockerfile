from java
run mkdir /opt/guacamole
workdir /opt/guacamole
run apt-get update -yq && apt-get upgrade -yq &&\
    apt-get install -yq maven git
run git clone git://github.com/apache/incubator-guacamole-client.git
workdir /opt/guacamole/incubator-guacamole-client
run mvn package

# add guacamole-auth-noauth-0.9.10-incubating/guacamole-auth-noauth-0.9.10-incubating.jar /opt/guacamole/extensions
# add guacamole-auth-noauth-0.9.10-incubating/doc/example/noauth-config.xml /opt/guacamole/noauth-config.xml
# run echo "noauth-config: /opt/guacamole/noauth-config.xml" >> guacamole.properties &&\
#     sed -i "s/rdp/vnc/g" noauth-config.xml &&\
#     sed -i "s/name=\"port\" value=\"3389\"/name=\"port\" value=\"5900\"/g" noauth-config.xml
workdir /usr/local/tomcat
cmd /opt/guacamole/bin/start.sh
