FROM nicolaka/netshoot:v0.11

RUN curl -sL --http1.1 https://cnfl.io/cli | sh -s -- -b /usr/local/bin v3.24.0

RUN curl -O https://packages.confluent.io/archive/7.4/confluent-7.4.1.tar.gz && \
    tar xzf confluent-7.4.1.tar.gz && \
    cp -rT confluent-7.4.1/bin /usr/local/bin && \
    rm -rf confluent-7.4.1

RUN apk add kafkacat

CMD sleep infinity