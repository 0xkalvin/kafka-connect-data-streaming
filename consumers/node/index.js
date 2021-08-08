const { Kafka } = require("kafkajs");

const config = {
    clientId: process.env.KAFKA_CLIENT_ID || 'tweetconsumer', 
    brokers: [process.env.KAFKA_BROKERS || "localhost:9092"],
    groupId: process.env.KAFKA_GROUP_ID || "tweetconsumers",
    tweetsTopic: process.env.KAFKA_TWEETS_TOPIC || "test.public.Tweets",
    fromBeginning: true,
}

const kafka = new Kafka({
  clientId: config.clientId,
  brokers:  config.brokers,
});

(async () => {

  const consumer = kafka.consumer({ groupId: config.groupId });

  await consumer.connect();

  await consumer.subscribe({ topic: config.tweetsTopic, fromBeginning: config.fromBeginning });

  await consumer.run({
    eachMessage: async ({ message }) => {
        console.info("Processing message");
        console.info("Key", message.key.toString());
        console.info("value", message.value.toString());
    }
  });
})();