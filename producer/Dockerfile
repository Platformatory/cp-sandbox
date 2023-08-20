# Use a base Maven image for building
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .

# Install Maven dependencies
RUN mvn dependency:go-offline

# Copy the rest of the project files
COPY src/ src/

# Build the application JAR file
RUN mvn clean package

FROM nicolaka/netshoot:v0.11

# Set the working directory inside the container
WORKDIR /app

RUN curl -O https://packages.confluent.io/archive/7.4/confluent-7.4.1.tar.gz && \
    tar xzf confluent-7.4.1.tar.gz && \
    cp -rT confluent-7.4.1/bin /usr/local/bin

RUN apk add kafkacat openjdk11-jre

ENV CONFLUENT_HOME=/app/confluent-7.4.1

ENV PATH /sbin:/app/confluent-7.4.1/bin/:$PATH

# Copy the compiled JAR file from the build stage
COPY --from=build /app/target/kafka-example-1.0-SNAPSHOT.jar app.jar

# Run the Kafka producer by default
CMD ["java", "-jar", "app.jar", "/opt/client/client.properties"]
