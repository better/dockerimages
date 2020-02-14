#!/bin/sh
exec bash $ZOOKEEPER_HOME/bin/zkServer.sh start-foreground $ZOOKEEPER_HOME/conf/zoo.cfg
