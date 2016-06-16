FROM alpine:3.4
MAINTAINER Toon Van Dooren <toon@weepee.org>

ENV JAVA_VERSION 8.92.14-r1
ENV ELASTICSEARCH_VERSION 1.5.2

RUN apk update && apk add tzdata bash tar rsync ca-certificates curl openjdk8-jre-base=$JAVA_VERSION wget && \
apk upgrade && \
cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
echo "Europe/Brussels" > /etc/timezone && \
mkdir -p /opt && \
mkdir -p /var/lib/elasticsearch \
cd /tmp && \
curl https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz > elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
tar -xzf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
rm -rf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && \
mv elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch && \
rm -fr /tmp/* && \
rm -f /var/cache/apk/*

ADD ./cfg/elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
ADD ./scripts/start.sh /scripts/start.sh

RUN chmod -R a+rx /scripts && \
chmod -R a+rwx /opt/ && \
chmod -R a+rwx /var/lib && rm -fr /var/lib/elasticsearch

EXPOSE 9200
EXPOSE 9300

CMD ["/scripts/start.sh"]

RUN /opt/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-icu/2.5.0 && \
/opt/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-phonetic/2.5.0