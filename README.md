# Kafka connect data streaming

A data hub/streaming example solution that uses Kafka Connect to distribute data across many targets, such as Postgres, Elasticsearch, Consumers, and DynamoDB.

## Scenario

- A Postgres database for storing tweets as our data source.
- Each time a new tweet is inserted in this postgres instance, we must enqueue the new record in a kafka topic.
- From the kafka topic, each new recorded can be consumed by many actors for different use cases. In this example, our topic will be consumed by a consumer application, a JDBC postgres sink connector that replicates data to another postgres instance, a dynamoDB sink connector, and also an elasticsearch sink connector.

## Setup

### Requirements

- Docker
- Docker compose
- Unix-like OS 

### Running locally

To start up the environment, just run
```sh
make
```
When everything is up and running, you should see:
- One Kafka broker with a zookeeper container as our messaging queue.
- One Kafka connect container to pipe data between data sources and targets.
- Two Postgres containers: one as our data source and other as a data target for our tweets.
- One Elasticsearch container as another replication target.
- One DynamoDB container also as a target.
- Lastly but not least, one consumer app written in Node.js which just console logs each new tweet.

Then we can start creating each connector for our data hub.

Postgres source connector:
```sh
. ./scripts/debezium_postgres_source_connector.sh
```

Postgres sink (target) connector:
```sh
. ./scripts/jdbc_postgres_sink_connector.sh
```

Dynamodb sink (target) connector:
```sh
. ./scripts/dynamodb_sink_connector.sh
```

Elasticsearch sink (target) connector:
```sh
. ./scripts/elasticsearch_sink_connector.sh
```

Populate the data source with dummy data to test our data replication pipelines:

```sh
 docker-compose exec postgressource psql -h localhost -p 5431 -U postgres -d postgres -c "INSERT INTO \"Tweets\" (id, account_id, content, created_at, updated_at) SELECT random(), random(),random(), now(), now() from generate_series(1,1000)"
```

Then check each data target and see if tweets being replicated:

Postgres target
```sh
 docker-compose exec postgrestarget psql -h localhost -p 5431 -U postgres -d postgres -c "SELECT * FROM \"Tweets\""
```

Dynamodb
```sh
aws dynamodb scan --table-name test.public.Tweets --endpoint http://localhost:8000 --region us-east-1
```

Elasticsearch
```sh
curl http://localhost:9200/test.public.tweets/_search?pretty
```
