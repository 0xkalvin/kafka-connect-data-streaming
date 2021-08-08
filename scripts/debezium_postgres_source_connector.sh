#!/bin/bash

curl -i -XPOST \
    -H "Accept:application/json" \
    -H  "Content-Type:application/json" \
    http://localhost:8083/connectors/ -d '
    {
      "name": "debeziumpostgresconnector",
      "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "tasks.max": "1",
        "database.hostname": "postgressource",
        "plugin.name": "wal2json_streaming",
        "database.port": "5431",
        "database.user": "postgres",
        "database.password": "postgres",
        "database.dbname": "postgres",
        "database.server.name": "test",
        "table.include.list": "public.Tweets",
        "database.history.kafka.bootstrap.servers": "http://kafka:9092",
        "database.history.kafka.topic": "schema.changes.test.datastreaming",
        "include.schema.changes": "true",
        "slot.name": "debezium",
        "max.queue.size": "81290",
        "max.batch.size": "20480",
        "key.converter": "io.confluent.connect.avro.AvroConverter",
        "value.converter": "io.confluent.connect.avro.AvroConverter",
        "key.converter.schema.registry.url": "http://schemaregistry:8081",
        "value.converter.schema.registry.url": "http://schemaregistry:8081",
        "snapshot.mode": "exported"
      }
    }
'
