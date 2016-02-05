#!/bin/bash

# Function to get IP address for host
get_addr () {
  ping -c 1 $1 | head -1 | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'
}

# Self-reference in /etc/hosts
MYIP=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1`
echo "My IP address: $MYIP"

if [  $ZOOKEEPER_NODE_COUNT -gt 1 ]; then
    for i in $(seq 1 $ZOOKEEPER_NODE_COUNT)
    do
      IP=`get_addr ${ZOOKEEPER_NODE_PREFIX}_${i}`
      echo "Zookeeper node $i: $IP (${ZOOKEEPER_NODE_PREFIX}_${i})"
      if [ $IP == $MYIP ]; then
      	export MYID=$i
      fi
    done
fi

# Populate zoo.cfg
echo "Creating zoo.cfg..."
touch ${ZOOKEEPER_HOME}/conf/zoo.cfg
echo "dataDir=${ZOOKEEPER_DATA_DIR}" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
echo "dataLogDir=${ZOOKEEPER_LOG_DIR}" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
echo "tickTime=${ZOOKEEPER_TICK_TIME}" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
echo "clientPort=${ZOOKEEPER_CLIENT_PORT}" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
echo "initLimit=${ZOOKEEPER_INIT_LIMIT}" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
echo "syncLimit=${ZOOKEEPER_SYNC_LIMIT}" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg

if [  $ZOOKEEPER_NODE_COUNT -gt 1 ]; then
    for i in $(seq 1 $ZOOKEEPER_NODE_COUNT)
    do
      echo "server.$i=${ZOOKEEPER_NODE_PREFIX}_${i}:${ZOOKEEPER_QUORUM_PORT}:${ZOOKEEPER_LEADER_ELECTION_PORT}" >> ${ZOOKEEPER_HOME}/conf/zoo.cfg
    done
fi

echo "Filling ${ZOOKEEPER_DATA_DIR}/myid..."
echo ${MYID} > ${ZOOKEEPER_DATA_DIR}/myid

exec "$@"
