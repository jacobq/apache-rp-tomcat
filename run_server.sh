#!/bin/bash

trap 'killall' INT

killall() {
    trap '' INT TERM     # ignore INT and TERM while shutting down
    echo "**** Stopping Apache httpd ****"
    /usr/local/apache2/bin/apachectl stop
    echo "**** Stopping Apache Tomcat ****"
    /usr/local/tomcat/bin/catalina.sh stop 30
    echo "**** Terminating remaining running processes ****"
    kill -TERM 0 > /dev/null
}

/usr/local/apache2/bin/apachectl restart

/usr/local/tomcat/bin/catalina.sh stop 10 -force
/usr/local/tomcat/bin/catalina.sh start

cat # wait forever