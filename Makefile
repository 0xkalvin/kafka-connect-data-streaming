all: postgres zookeeper kafka schemaregistry kafkaconnect dynamodb elasticsearch
.PHONY: all

default: all

down:
	@docker-compose down -v --rmi local
.PHONY: down

dynamodb:
	@docker-compose up -d dynamodb
.PHONY: dynamodb

elasticsearch:
	@docker-compose up -d elasticsearch
.PHONY: elasticsearch

kafka:
	@docker-compose up -d kafka
.PHONY: kafka

kafkaconnect:
	@docker-compose up -d kafkaconnect
.PHONY: kafkaconnect

nodeconsumer:
	@docker-compose up nodeconsumer
.PHONY: nodeconsumer

postgres:
	@docker-compose up -d postgressource postgrestarget
.PHONY: postgres

schemaregistry:
	@docker-compose up -d schemaregistry
.PHONY: schemaregistry

zookeeper:
	@docker-compose up -d zookeeper
.PHONY: zookeeper
