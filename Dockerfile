ARG TIKA_VERSION=2.0.0
ARG TESSERACT-OCR-POR_VERSION=1:4.00~git30-7274cfa-1

FROM apache/tika:$TIKA_VERSION

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get -y --no-install-recommends install tesseract-ocr-por=${TESSERACT-OCR-POR_VERSION} \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
