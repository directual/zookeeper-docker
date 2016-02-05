# Using Java 8 official image, based on Debian Jessie
FROM java:8-jre
MAINTAINER Artyom Artemiev <cptn.foxmk@gmail.com>

# Download and install Zookeeper
ENV ZOOKEEPER_VERSION 3.4.6
RUN wget -q -O /tmp/zookeeper.tar.gz http://www.eu.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz \
 && tar -xzf /tmp/zookeeper.tar.gz -C /opt  \
 && rm -f /tmp/zookeeper.tar.gz

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

VOLUME [ "/var/lib/zookeeper" ]
VOLUME [ "/var/log/zookeeper" ]

# Default settings
ENV ZOOKEEPER_HOME /opt/zookeeper-$ZOOKEEPER_VERSION
ENV ZOOKEEPER_DATA_DIR /var/lib/zookeeper
ENV ZOOKEEPER_LOG_DIR /var/log/zookeeper
ENV ZOOKEEPER_TICK_TIME 2000
ENV ZOOKEEPER_INIT_LIMIT 5
ENV ZOOKEEPER_SYNC_LIMIT 2
ENV ZOOKEEPER_CLIENT_PORT 2181
ENV ZOOKEEPER_QUORUM_PORT 2888
ENV ZOOKEEPER_LEADER_ELECTION_PORT 3888
ENV ZOOKEEPER_NODE_PREFIX zookeeper_node

ENV ZOOKEEPER_NODE_COUNT 1

EXPOSE $ZOOKEEPER_CLIENT_PORT
EXPOSE $ZOOKEEPER_QUORUM_PORT
EXPOSE $ZOOKEEPER_LEADER_ELECTION_PORT

ENV PATH $ZOOKEEPER_HOME/bin:$PATH
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "zkServer.sh", "start-foreground" ]
