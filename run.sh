#!/bin/bash

# Remode old containers
docker rm -f elk-elasticsearch
docker rm -f elk-kibana

# Create data directory if it does not exist.
# Data directory will be link to elasticsearch container in order to store data
if [ ! -d "$PWD/data" ]
then
	mkdir data
fi

# Run elasticsearch, logstash and kibana containers
docker run -d -P --name elk-elasticsearch -v "$PWD/data":/usr/share/elasticsearch/data elasticsearch:2.2
docker run -d -P --name elk-kibana --link elk-elasticsearch:elasticsearch kibana:4.4
docker run -it --rm --link elk-elasticsearch:elasticsearch -v "$PWD/conf":/config-dir -v "$PWD/tmp/":/tmp logstash:2.2 logstash -f /config-dir/logstash.conf
