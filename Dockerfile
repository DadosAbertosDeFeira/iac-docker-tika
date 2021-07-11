ARG TIKA_VERSION=1.27
FROM apache/tika:$TIKA_VERSION

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get -y --no-install-recommends install tesseract-ocr-por \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
