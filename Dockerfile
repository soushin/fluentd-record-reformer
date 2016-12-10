FROM fluent/fluentd:latest-onbuild
MAINTAINER nsoushi <nsoushi@nsoushi>

USER root
RUN apk --no-cache --update add sudo build-base ruby-dev && \
    apk --no-cache --update add bash tzdata && \
    apk --no-cache add --virtual=build-dependencies wget && \
    apk del sudo build-base ruby-dev && rm -rf /var/cache/apk/**

ENV PATH /home/fluent/.gem/ruby/2.2.0/bin:$PATH
RUN gem install fluent-plugin-elasticsearch && \
    gem install fluent-plugin-record-reformer && \
    rm -rf /home/fluent/.gem/ruby/2.3.0/cache/*.gem && gem sources -c

COPY common /fluentd/etc/common/
COPY conf.d /fluentd/etc/conf.d

USER root
ENTRYPOINT [ \
    "fluentd", "-c", "/fluentd/etc/fluent.conf", "-p", "/fluentd/plugins" \
]
