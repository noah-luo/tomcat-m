#!/bin/bash
script_dir=$(cd `dirname $0`; pwd)
root_dir=$(dirname $(dirname $script_dir))
tomcat_dir=$root_dir/tomcat    #tomcat主目录
app_dir=$root_dir/instances    #多实例主目录

#JAVA_OPTS="-Dfile.encoding=UTF-8 -server -Xms6144m -Xmx6144m -XX:NewSize=1024m -XX:MaxNewSize=2048m -XX:PermSize=512m -XX:MaxPermSize=512m -XX:MaxTenuringThreshold=10 -XX:NewRatio=2 -XX:+DisableExplicitGC"
export JAVA_OPTS="-Xms100m -Xmx200m"
export JAVA_HOME="/usr/java/jdk1.8.0_121"
export CATALINA_HOME=$tomcat_dir
export CATALINA_BASE=$script_dir



case $1 in
    start)
        $CATALINA_HOME/bin/catalina.sh start
        echo start success!!
        ;;
    stop)
        $CATALINA_HOME/bin/catalina.sh stop
        echo stop success!!
        ;;
    restart)
        $CATALINA_HOME/bin/catalina.sh restart
        echo restart success!!
        ;;
    version)
        $CATALINA_HOME/bin/catalina.sh version
        ;;
    configtest)
        $CATALINA_HOME/bin/catalina.sh configtest
        ;;
esac
exit 0
