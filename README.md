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

# Scenario 8

> **Before starting ensure that there are no other versions of the sandbox running**
> Run `docker-compose down -v` before starting

1. Start the scenario with `docker-compose up -d`
2. Wait for all services to be up and healthy `docker-compose ps`


## Problem Statement

The kafka brokers are down after an upgrade to a newer version. Several properties and files were changed during the upgrade and the customer does not have an audit of the changes.

Review the logs and come up with a solution to start the kafka brokers.

```
org.apache.kafka.common.config.ConfigException: Invalid value javax.net.ssl.SSLHandshakeException: Empty client certificate chain for configuration A client SSLEngine created with the provided settings can't connect to a server SSLEngine created with those settings.
	at org.apache.kafka.common.security.ssl.SslFactory.configure(SslFactory.java:103)
	at org.apache.kafka.common.network.SslChannelBuilder.configure(SslChannelBuilder.java:84)
	at org.apache.kafka.common.network.ChannelBuilders.create(ChannelBuilders.java:265)
	at org.apache.kafka.common.network.ChannelBuilders.serverChannelBuilder(ChannelBuilders.java:166)
	at kafka.network.Processor.<init>(SocketServer.scala:1177)
	at kafka.network.Acceptor.newProcessor(SocketServer.scala:1050)
	at kafka.network.Acceptor.$anonfun$addProcessors$1(SocketServer.scala:1010)
	at scala.collection.immutable.Range.foreach$mVc$sp(Range.scala:190)
	at kafka.network.Acceptor.addProcessors(SocketServer.scala:1009)
	at kafka.network.DataPlaneAcceptor.configure(SocketServer.scala:670)
	at kafka.network.SocketServer.createDataPlaneAcceptorAndProcessors(SocketServer.scala:278)
	at kafka.network.SocketServer.$anonfun$new$51(SocketServer.scala:224)
	at kafka.network.SocketServer.$anonfun$new$51$adapted(SocketServer.scala:224)
	at scala.collection.IterableOnceOps.foreach(IterableOnce.scala:575)
	at scala.collection.IterableOnceOps.foreach$(IterableOnce.scala:573)
	at scala.collection.AbstractIterable.foreach(Iterable.scala:933)
	at kafka.network.SocketServer.<init>(SocketServer.scala:224)
	at kafka.server.KafkaServer.startup(KafkaServer.scala:528)
	at kafka.Kafka$.main(Kafka.scala:114)
```
