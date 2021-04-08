# debezium-kafka-postgres-nodejs-example

A simple example of how to setup a CDC process using Debezium, Kafka, Postgres and consuming the events using a Node.JS consumer.

## Setup

Start up a postgres container that will be our data source.
```
docker run --rm --name postgres -p 5000:5432 -e POSTGRES_PASSWORD=postgres -d debezium/postgres
```

Start up a zookeeper container
```
docker run -it --rm --name zookeeper -p 2181:2181 -p 2888:2888 -p 3888:3888 -d debezium/zookeeper
```

Start up a kafka container 
```
docker run -it --rm --name kafka -p 9092:9092 -d --link zookeeper:zookeeper debezium/kafka
```

Start up a kafka connect container 
```
docker run -it --rm --name connect -p 8083:8083 -e GROUP_ID=1 -e CONFIG_STORAGE_TOPIC=my-connect-configs -e OFFSET_STORAGE_TOPIC=my-connect-offsets -e ADVERTISED_HOST_NAME=$(echo $DOCKER_HOST | cut -f3 -d'/' | cut -f1 -d':') --link zookeeper:zookeeper --link postgres:postgres --link kafka:kafka -d debezium/connect
```

Connect to the postgres container and create an user table

```
psql -h localhost -p 5000 -d postgres -U postgres

create table users (id serial primary key, name varchar(255));
```

Create a connector bewteen the source postgres and the kafka container
```
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-source-postgres.json
```

Check if it was successfully created
```
curl -H "Accept:application/json" http://localhost:8083/connectors/ | tac | tac

curl -X GET -H "Accept:application/json" http://localhost:8083/connectors/users-connector | tac | tac
```


Now start the Node.js consumer process

```
node consumer.js
```

Kafka also exposes a script to watch a topic and consume its messages
```
docker run -it --name watcher --rm --link zookeeper:zookeeper --link kafka:kafka debezium/kafka watch-topic -a -k dbserver1.public.users
```