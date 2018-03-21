FROM php:apache
LABEL maintainer="https://github.com/h3po"

#presumably the commit that is v013b (@computersalat updated the readme)
ARG COMMIT=3d368459e0ce829eb74d7e311d5a196004996ade

ADD https://github.com/MoonchildProductions/FSyncMS/archive/${COMMIT}.tar.gz /tmp

RUN \
    docker-php-ext-install pdo pdo_mysql && \
    tar xf /tmp/*.tar.gz -C /tmp && \
    rm /tmp/*.tar.gz && \
    mv /tmp/FSyncMS-${COMMIT}/*.php /var/www/html/

ENV DBTYPE=sqlite
ENV DBHOST=db
ENV DBNAME=fsyncms
ENV DBUSER=fsyncms
ENV DBPASS=snakeoil
ENV ENABLE_REGISTER=true

VOLUME /var/www/html

COPY setup.sh /

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "/setup.sh && docker-php-entrypoint apache2-foreground"]
