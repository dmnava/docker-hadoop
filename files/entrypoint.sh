#!/bin/bash
. /etc/profile.d/hadoop.sh 

if [ "$1" = 'namenode' ]; then
  if [ ! -f /data/hadoop/dfs/name/current/VERSION ]
  then
    echo Formatting HDFS...
    $HADOOP_PREFIX/bin/hdfs namenode -format
  fi
  echo Starting HDFS Namenode...
#  $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR start namenode
  exec $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode 

elif [ "$1" = 'datanode' ]; then
  if [ -z $MASTER_IP_ADDRESS ]; then
    echo MASTER_IP_ADDRESS env property not set!!
    exit 1
  fi
  echo Starting HDFS Datanode...
#  $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR start datanode
  exec $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR datanode 
fi

exec "$@"
