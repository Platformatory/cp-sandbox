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

kafka-topics --bootstrap-server kafka1:19092 --command-config /tmp/client.properties --create --topic inventory_changes --if-not-exists

sleep infinity