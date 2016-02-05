# Zookeeper Docker image

Docker image with Apache Zookeeper based on official Java 8 image. Uses Docker 1.10 DNS resolving capability.


## Environment variables

#### `ZOOKEEPER_NODE_COUNT`

Default value: `1`

Number of Zookeeper node containers. All containers must be in the same Docker network.

#### `ZOOKEEPER_NODE_PREFIX`

Default value: `zookeeper_node`

Prefix for container name. Example: if `ZOOKEEPER_NODE_PREFIX=zk_node` and `ZOOKEEPER_NODE_COUNT=3` then containers should have names: `zk_node_1`, `zk_node_2` and `zk_node_3`.

#### `ZOOKEEPER_DATA_DIR`

Default value: `/var/lib/zookeeper`

#### `ZOOKEEPER_LOG_DIR`

Default value: `/var/log/zookeeper`

#### `ZOOKEEPER_TICK_TIME`

Default value: `2000`

#### `ZOOKEEPER_INIT_LIMIT`

Default value: `5`

#### `ZOOKEEPER_SYNC_LIMIT`

Default value: `2`

#### `ZOOKEEPER_CLIENT_PORT`

Default value: `2181`

#### `ZOOKEEPER_QUORUM_PORT`

Default value: `2888`

#### `ZOOKEEPER_LEADER_ELECTION_PORT`

Default value: `3888`


## Usage

Starting cluster with `run-cluster.sh`: 

```sh
> docker build -t directual/zookeeper .
...
> docker network create zknet
> ./run-cluster

> ./run-cluster zknet 3
...
```

Starting nodes manually:

```sh
> docker network create zknetwork
> docker run -d \
    --env ZOOKEEPER_NODE_COUNT=3 \
    --env ZOOKEEPER_NODE_PREFIX=zk_node \
    --net zknetwork \
    --name zk_node_1 \
    directual/zookeeper
> docker run -d \
    --env ZOOKEEPER_NODE_COUNT=3 \
    --env ZOOKEEPER_NODE_PREFIX=zk_node \
    --net zknetwork \
    --name zk_node_2 \
    directual/zookeeper
> docker run -d \
    --env ZOOKEEPER_NODE_COUNT=3 \
    --env ZOOKEEPER_NODE_PREFIX=zk_node \
    --net zknetwork \
    --name zk_node_3 \
    directual/zookeeper
```