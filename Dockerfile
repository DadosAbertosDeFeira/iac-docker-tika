FROM ubuntu:focal as dependencies 

ARG JRE='openjdk-14-jre-headless'
ARG TIKA_VERSION='1.25'
ARG CHECK_SIG=true

ENV NEAREST_TIKA_SERVER_URL="https://www.apache.org/dyn/closer.cgi/tika/tika-server-${TIKA_VERSION}.jar?filename=tika/tika-server-${TIKA_VERSION}.jar&action=download" \
    ARCHIVE_TIKA_SERVER_URL="https://archive.apache.org/dist/tika/tika-server-${TIKA_VERSION}.jar" \
    DEFAULT_TIKA_SERVER_ASC_URL="https://downloads.apache.org/tika/tika-server-${TIKA_VERSION}.jar.asc" \
    ARCHIVE_TIKA_SERVER_ASC_URL="https://archive.apache.org/dist/tika/tika-server-${TIKA_VERSION}.jar.asc" \
    TIKA_VERSION=$TIKA_VERSION

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y --no-install-recommends install gnupg2 wget \
        $JRE gdal-bin tesseract-ocr \
        tesseract-ocr-eng tesseract-ocr-por \
        # Fonts
        && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
        && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y xfonts-utils fonts-freefont-ttf fonts-liberation ttf-mscorefonts-installer wget cabextract \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
        && echo "Download do Servidor Tika" \
        && wget -t 10 --max-redirect 1 --retry-connrefused -qO- https://downloads.apache.org/tika/KEYS | gpg --import \
        && wget -t 10 --max-redirect 1 --retry-connrefused $NEAREST_TIKA_SERVER_URL -O /tika-server-${TIKA_VERSION}.jar || rm /tika-server-${TIKA_VERSION}.jar \
        && sh -c "[ -f /tika-server-${TIKA_VERSION}.jar ]" || wget $ARCHIVE_TIKA_SERVER_URL -O /tika-server-${TIKA_VERSION}.jar || rm /tika-server-${TIKA_VERSION}.jar \
        && sh -c "[ -f /tika-server-${TIKA_VERSION}.jar ]" || exit 1 \
        && wget -t 10 --max-redirect 1 --retry-connrefused $DEFAULT_TIKA_SERVER_ASC_URL -O /tika-server-${TIKA_VERSION}.jar.asc  || rm /tika-server-${TIKA_VERSION}.jar.asc \
        && sh -c "[ -f /tika-server-${TIKA_VERSION}.jar.asc ]" || wget $ARCHIVE_TIKA_SERVER_ASC_URL -O /tika-server-${TIKA_VERSION}.jar.asc || rm /tika-server-${TIKA_VERSION}.jar.asc \
        && sh -c "[ -f /tika-server-${TIKA_VERSION}.jar.asc ]" || exit 1 ;

RUN if [ "$CHECK_SIG" = "true" ] ; then gpg --verify /tika-server-${TIKA_VERSION}.jar.asc /tika-server-${TIKA_VERSION}.jar; fi

EXPOSE 9998
ENTRYPOINT [ "/bin/sh", "-c", "exec java -jar /tika-server-${TIKA_VERSION}.jar -h 0.0.0.0 $0 $@"]

LABEL maintainer="Apache Tika Developers dev@tika.apache.org"
