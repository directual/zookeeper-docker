#!/usr/bin/env bash

NODE_COUNT=$2
DOCKER_NETWORK=$1
NODE_PREFIX=${3:-zookeeper_node}

USAGE="Usage: $0 DOCKER_NETWORK NODE_COUNT [NODE_PREFIX]"

if [ -z $DOCKER_NETWORK ] || [ -z $NODE_COUNT ]; then
    echo $USAGE
    exit 1
fi

for i in $(seq 1 $NODE_COUNT)
do
  docker run \
    -d \
    --env ZOOKEEPER_NODE_COUNT=$NODE_COUNT \
    --env ZOOKEEPER_NODE_PREFIX=$NODE_PREFIX \
    --net $DOCKER_NETWORK \
    --name ${NODE_PREFIX}_${i} \
    directual/zookeeper
done
