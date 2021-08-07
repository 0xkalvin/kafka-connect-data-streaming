all: postgres zookeeper kafka schemaregistry kafkaconnect
.PHONY: all

kafka:
	@docker-compose up -d kafka
.PHONY: kafka

kafkaconnect:
	@docker-compose up -d kafkaconnect
.PHONY: kafkaconnect

default: all

down:
	@docker-compose down -v --rmi local
.PHONY: down

postgres:
	@docker-compose up -d postgressource postgrestarget
.PHONY: postgres

schemaregistry:
	@docker-compose up -d schemaregistry
.PHONY: schemaregistry

zookeeper:
	@docker-compose up -d zookeeper
.PHONY: zookeeper
