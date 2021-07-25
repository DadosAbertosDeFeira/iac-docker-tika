ARG TIKA_VERSION=1.26
FROM apache/tika:$TIKA_VERSION

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get -y --no-install-recommends install tesseract-ocr-por=1:4.00~git30-7274cfa-1 \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
