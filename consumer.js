const { Kafka } = require("kafkajs");
const { Pool } = require("pg");

const kafka = new Kafka({
  clientId: "consumer-app",
  brokers: ["localhost:9092"],
});

const postgresPool = new Pool({
  user: "postgres",
  database: "postgres",
  password: "postgres",
  port: 5001,
  host: "localhost",
  keepAlive: true,
  max: 90,
});

(async () => {
  postgresPool
    .query("SELECT NOW() as now")
    .then((_) => console.log("Connected to postgres"))
    .catch(console.error);

  const consumer = kafka.consumer({ groupId: "consumer-group" });

  await consumer.connect();

  await consumer.subscribe({ topic: "dbserver1.public.users" });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      const parsedMessage = JSON.parse(message.value.toString());
      const userPayload = parsedMessage.payload.after;

      const postgresConnection = await postgresPool.connect();

      try {
        await postgresConnection.query("BEGIN");

        await postgresConnection.query(
          "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE"
        );

        const doesUserAlreadyExist = await postgresConnection.query(
          "select exists(select 1 from users where id=$1)",
          [userPayload.id]
        );

        if (!doesUserAlreadyExist.rows[0].exists) {
          const {
            rows,
          } = await postgresConnection.query(
            "INSERT INTO users(id, name) VALUES($1, $2) RETURNING *",
            [userPayload.id, userPayload.name]
          );

          console.log(rows);
        }

        await postgresConnection.query("COMMIT");
      } catch (e) {
        await postgresConnection.query("ROLLBACK");
        throw e;
      } finally {
        postgresConnection.release();
      }
    },
  });
})();
