# Introduction

This project provides connectors for Kafka Connect to read and write data to DynamoDB.

# Documentation

Documentation on the connector is hosted on Confluent's
[docs site](https://docs.confluent.io/current/connect/kafka-connect-dynamodb/).

Source code is located in Confluent's
[docs repo](https://github.com/confluentinc/docs/tree/master/connect/kafka-connect-dynamodb). If changes
are made to configuration options for the connector, be sure to generate the RST docs (as described
below) and open a PR against the docs repo to publish those changes!

# Configs

Documentation on the configurations for each connector can be automatically generated via Maven.

To generate documentation for the sink connector:
```bash
mvn -Pdocs exec:java@sink-config-docs
```

To generate documentation for the source connector:
```bash
mvn -Pdocs exec:java@source-config-docs
```

# Compatibility Matrix:

This connector has been tested against the following versions of Apache Kafka
and DynamoDB:

|                          | AK 1.0             | AK 1.1        | AK 2.0        |
| ------------------------ | ------------------ | ------------- | ------------- |
| **DynamoDB v1.2.3** | NOT COMPATIBLE (1) | OK            | OK            |

1. The connector needs header support in Connect.

# Integration Tests

Integration tests work out of the box for this connector; simply run them without any modifications.
