# kafka-jmx-grafana-docker

Docker-compose file for Confluent Kafka with configuration mounted as properties files. Brings up Kafka and components with JMX metrics exposed and visualized using Prometheus and Grafana

## Start

```
docker-compose up -d
```

## Usage

The docker-compose file brings up 3 node kafka cluster with security enabled. Each service in the compose file has its properties/configurations mounted as a volume from a directory with the same name as the service.

Check the kafka server.properties for more details about the Kafka setup.

### Health

Check if all components are up and running using

```bash
docker-compose ps -a
# Ensure there are no Exited services and all containers have the status `Up`
```


### Client

To use a kafka client, exec into the `kfkclient` container which contains the Kafka CLI and other tools necessary for troubleshooting Kafka. THe `kfkclient` container also contains a properties file mounted to `/opt/client`, which can be used to define the client properties for communicating with Kafka.

```
docker exec -it kfkclient bash
```

### Logs

Check the logs of the respective service by its container name.

```bash
docker logs <container_name> # docker logs kafka1
```

### Restarting services

To restart a particular service - 

```bash
docker-compose restart <service_name> # docker-compose restart kafka1
# OR
docker-compose up -d --force-recreate <service_name> # docker-compose up -d --force-recreate kafka1
```

# Scenario 3

> **Before starting ensure that there are no other versions of the sandbox running**
> Run `docker-compose down -v` before starting

1. Start the scenario with `docker-compose up -d`
2. Wait for all services to be up and healthy `docker-compose ps`

## Problem Statement

The client is unable to interact with the cluster using `kafka-topics`, `kafka-console-producer` or `kafka-console-consumer` using the super user `bob`(password - `bob-secret`) with some of the kakfa brokers as the bootstrap server. Only one of the kafka broker works as the bootstrap server.

The error message when using kafka2 or kafka3 as the bootstrap-server

```
[2023-07-26 13:20:58,720] ERROR [AdminClient clientId=adminclient-1] Connection to node 3 (kafka3/192.168.112.8:39092) failed authentication due to: Authentication failed: Invalid username or password (org.apache.kafka.clients.NetworkClient)
[2023-07-26 13:20:58,722] WARN [AdminClient clientId=adminclient-1] Metadata update failed due to authentication error (org.apache.kafka.clients.admin.internals.AdminMetadataManager)
org.apache.kafka.common.errors.SaslAuthenticationException: Authentication failed: Invalid username or password
Error while executing topic command : Authentication failed: Invalid username or password
[2023-07-26 13:20:58,907] ERROR org.apache.kafka.common.errors.SaslAuthenticationException: Authentication failed: Invalid username or password
```

Commands ran on the `kfkclient` host

```bash
kafka-topics --bootstrap-server <broker>:<port> --command-config /opt/client/client.properties --list
```
