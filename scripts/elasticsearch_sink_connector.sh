#!/bin/bash

curl -i -XPOST -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/ \
    -d '{
      "name": "elasticsearchsinkconnector",
      "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "topics": "test.public.Tweets",
        "key.ignore": "false",
        "schema.ignore": "true",
        "type.name": "type.name=kafkaconnect",
        "connection.url": "http://elasticsearch:9200",
        "transforms": "extractKey",
        "transforms.extractKey.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
        "transforms.extractKey.field":"id"
      }
    }'
