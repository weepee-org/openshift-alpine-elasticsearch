FROM       luislavena/mini-java
MAINTAINER Toon Van Dooren <toon@weepee.org>

RUN apk-install ca-certificates curl

ENV ELASTICSEARCH_VERSION 1.5.2

RUN \
  mkdir -p /opt && \
  cd /tmp && \
  curl https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz > elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  rm -rf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
  mv elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch

ADD ./cfg/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
ADD ./scripts/start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

VOLUME ["/var/lib/elasticsearch"]

EXPOSE 9200
EXPOSE 9300

CMD ["/scripts/start.sh"]
