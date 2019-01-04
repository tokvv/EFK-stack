FROM fluent/fluentd:v1.3-debian
RUN mkdir /etc/fluent

RUN apt-get update && apt-get install --yes make libcurl4-gnutls-dev && apt-get clean all

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install \
        fluent-plugin-elasticsearch \
    fluent-plugin-concat \
    fluent-plugin-docker_metadata_filter \
    fluent-plugin-grep \
        fluent-plugin-rewrite-tag-filter \
    fluent-plugin-multi-format-parser \
    fluent-plugin-grok-parser \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

COPY fluent.conf /etc/fluent 
ADD run.sh /run.sh

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
