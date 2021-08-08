#!/bin/bash

curl -i -X POST \
  -H "Accept:application/json" \
  -H  "Content-Type:application/json" \
  http://localhost:8083/connectors/ -d '
  {
      "name": "jdbcpostgressinkconnector",
      "config": {
          "auto.create": "false",
          "connection.password": "postgres",
          "connection.url": "jdbc:postgresql://postgrestarget:5432/postgres?stringtype=unspecified",
          "connection.user": "postgres",
          "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
          "table.name.format": "Tweets",
          "topics": "test.public.Tweets",

          "pk.fields": "id",
          "pk.mode": "record_key",
          "insert.mode": "insert",

          "transforms": "unwrap",
          "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
          "transforms.unwrap.drop.tombstones": "false"

      }
    }
  '
