#!/bin/bash
. /etc/profile.d/hadoop.sh 

if [[ "$1" = 'namenode' || $1 = 'resourcemanager' || $1 = 'hadoop-master' ]]; then
  if [[ "$1" = 'namenode' || $1 = 'hadoop-master' ]]; then
    if [[ ! -f /data/hadoop/dfs/name/current/VERSION ]]
    then
      echo Formatting HDFS...
      $HADOOP_PREFIX/bin/hdfs namenode -format
    fi
    if [[ $1 = 'namenode' ]];then
      echo Starting HDFS Namenode...
      exec $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode 
    else
      echo Starting HDFS Namenode and YARN Resource Manager
      exec /usr/bin/supervisord -c /etc/supervisor/supervisord-hadoop-master.conf
    fi
  fi
elif [[ $1 = 'resourcemanager' ]]; then
    echo Starting YARN ResourceManager...
    exec $HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR resourcemanager 

elif [[ $1 = 'datanode' || $1 = 'nodemanager' || $1 = 'hadoop-worker' ]]; then
  if [ -z $MASTER_IP_ADDRESS ]; then
    echo MASTER_IP_ADDRESS env property not set!!
    exit 1
  fi
  if [[ $1 = 'datanode' ]]; then
    echo Starting HDFS Datanode...
    exec $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR datanode 
  elif [[ $1 = 'nodemanager' ]]; then
    echo Starting YARN NodeManager...
    exec $HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR nodemanager 
  else
    echo Starting HDFS Datanode and YARN Nodemanager
    exec /usr/bin/supervisord -c /etc/supervisor/supervisord-hadoop-worker.conf
  fi
fi

exec "$@"
