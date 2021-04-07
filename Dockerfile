FROM openjdk:11
RUN apt-get update && apt-get install -y build-essential libz-dev wget unzip ocaml-nox git ocaml-native-compilers --no-install-recommends

WORKDIR /tmp

# hash for 	2021-04-07 02:03, jarfile=3.2M	
RUN export TLA_TOOLS_SHA256=7a9fa8100ec7bfb7a2a1961160d84b05fd10f8e49ea417dc76d03475b8cc0265

RUN mkdir -p /opt/tlaplus/lib && mkdir -p /opt/tlaplus/module

RUN wget https://tla.msr-inria.inria.fr/tlatoolbox/ci/dist/tla2tools.jar &&  echo "$TLA_TOOLS_SHA256 *tla2tools.jar" | sha256sum --check --strict -; && \
    mv tla2tools.jar /opt/tlaplus/lib/tla2tools.jar
    
# hash for 	2021-04-07 02:03, jarfile=3.2M	 

ADD target/tlaplus-monitor-0.1-jar-with-dependencies.jar /opt/tlaplus/lib
RUN echo "log4j.logger.org.apache.kafka=OFF" > /opt/tlaplus/lib/log4j.properties

ADD src/main/resources/modules/JsonUtils.tla /opt/tlaplus/module
ADD src/main/resources/modules/KafkaUtils.tla /opt/tlaplus/module

ADD bin/tlc /usr/local/bin/tlc


WORKDIR /root

ENTRYPOINT ["tlc"]
#EOF
