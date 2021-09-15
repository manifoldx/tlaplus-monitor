# syntax=docker/dockerfile:1
FROM azul/zulu-openjdk:11
# eclipse-temurin:11.0.12_7-jre-focal

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libz-dev \
  git \
  ocaml-native-compilers \
  ocaml-nox \
  wget \
  unzip \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN mkdir -p /opt/tlaplus/lib && mkdir -p /opt/tlaplus/module
COPY tla2tools.jar /opt/tlaplus/lib/tla2tools.jar
ADD target/tlaplus-monitor-1.0.0-SNAPSHOT-jar-with-dependencies.jar /opt/tlaplus/lib
RUN echo "log4j.logger.org.apache.kafka=OFF" > /opt/tlaplus/lib/log4j.properties

ADD src/main/resources/modules/JsonUtils.tla /opt/tlaplus/module
ADD src/main/resources/modules/KafkaUtils.tla /opt/tlaplus/module

ADD bin/tlc /usr/local/bin/tlc


WORKDIR /root

ENTRYPOINT ["tlc"]
