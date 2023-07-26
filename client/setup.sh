#!/bin/bash

until nc -z kafka1 19092
do
    echo "Waiting for Kakfa to be ready"
    sleep 5
done

cat <<EOF >>/tmp/client.properties
sasl.mechanism=PLAIN

security.protocol=SASL_PLAINTEXT

sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
  username="bob" \
  password="bob-secret";
EOF

kafka-topics --bootstrap-server kafka1:19092 --command-config /tmp/client.properties --create --topic domestic_orders --if-not-exists --replica-assignment 2

for x in {1..100}; do echo $x; sleep 2; done | kafka-console-producer --bootstrap-server kafka1:19092 --producer.config /tmp/client.properties --topic domestic_orders

sleep infinity