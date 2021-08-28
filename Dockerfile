ARG TIKA_VERSION

FROM apache/tika:$TIKA_VERSION

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
    # Pacote adicionado na versão mais recente para sanar quebra do CI por vulnerabilidade (CVE-2021-3711)
    openssl=1.1.1f-1ubuntu2.8 \
    # Pacote adicionado na versão mais recente para sanar quebra do CI por vulnerabilidade (CVE-2021-3711)
    libssl1.1=1.1.1f-1ubuntu2.8 \
    # Pacote adicionado na versão mais recente para sanar quebra do CI por vulnerabilidade (CVE-2021-33910)
    libsystemd0=245.4-4ubuntu3.11 \
    # Pacote adicionado na versão mais recente para sanar quebra do CI por vulnerabilidade (CVE-2021-33910)
    libudev1=245.4-4ubuntu3.11 \
    # este pacote já está instalado por padrão na imagem de origem. Será mantido apenas por segurança
    tesseract-ocr-por=1:4.00~git30-7274cfa-1 \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
