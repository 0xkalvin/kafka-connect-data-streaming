#!/bin/bash

curl -i -XPOST -H "Accept:application/json" \
    -H  "Content-Type:application/json" http://localhost:8083/connectors/ \
    -d '{
      "name": "dynamodbsinkconnector",
      "config": {
        "tasks.max": "1",
        "connector.class": "io.confluent.connect.aws.dynamodb.DynamoDbSinkConnector",
        "topics": "test.public.Tweets",
        "aws.dynamodb.region": "us-east-1",
        "aws.dynamodb.endpoint": "http://dynamodb:8000",
        "confluent.topic.bootstrap.servers": "http://kafka:9092",
        "confluent.topic.replication.factor": "1"
      }
    }'
