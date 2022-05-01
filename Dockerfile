ARG TIKA_VERSION

FROM midgardhero/tika:$TIKA_VERSION

USER root

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    openssl=1.1.1f-1ubuntu2.12 \
    libssl1.1=1.1.1f-1ubuntu2.12 \
    libsystemd0=245.4-4ubuntu3.16 \
    libudev1=245.4-4ubuntu3.16 \
    tesseract-ocr-por=1:4.00~git30-7274cfa-1 \
    libexpat1=2.2.9-1ubuntu0.4 \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# retorna o usuário para o padrão do TIKA
# https://github.com/apache/tika-docker/blob/a4556b9e774f4c576b198836cedae0597ed59506/minimal/Dockerfile#L19
USER 35002:35002
