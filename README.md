# Build da Imagem do Tika Server - Dados Abertos de Feira

[![Fluxo para construcao e publicacao do container](https://github.com/mmmarceleza/iac-docker-tika/actions/workflows/main.yml/badge.svg)](https://github.com/mmmarceleza/iac-docker-tika/actions/workflows/main.yml)

## :one: - Objetivo

Criar a imagem Docker do [Tika Server](https://cwiki.apache.org/confluence/display/TIKA/TikaServer) com as modificações necessárias para a utilização no projeto [Dados Abertos de Feira](https://www.dadosabertosdefeira.com.br) (ver [Dockerfile](https://github.com/mmmarceleza/iac-docker-tika/blob/main/Dockerfile)). 

Será utilizada a imagem base do [Apache Tika Server](https://hub.docker.com/r/apache/tika), travada na versão [1.25](https://hub.docker.com/layers/apache/tika/1.25/images/sha256-5a02aa906dad24c2b65a53fc20f946ecdc495c3ebd04e680dfb953d3658706af?context=explore) com a instalação do pacote [tesseract-ocr-por](https://packages.debian.org/sid/graphics/tesseract-ocr-por).

## :two: - Etapas do CI

O CI usado é o próprio [GitHub Actions](https://github.com/features/actions), com três jobs básicos (ver arquivo [main.yml](https://github.com/DadosAbertosDeFeira/iac-docker-tika/blob/main/.github/workflows/main.yml)):

- `job 01` - Lint do Dockerfile
- `job 02` - Teste do container
- `job 03` - Build e envio para o Docker Hub
- `job 04` - Scan da Imagem

### job 01 - Lint do Dockerfile

Esse job utiliza dois steps:

- `step 01-01` - [Checkout](https://github.com/marketplace/actions/checkout)
- `step 01-02` - [lint](https://github.com/marketplace/actions/docker-lint)

### job 02 - Teste do container

Esse job utiliza quatro steps:

- `step 02-01` - [Checkout](https://github.com/marketplace/actions/checkout)
- `step 02-02` - [Cache Docker layers](https://github.com/marketplace/actions/cache)
- `step 02-03` - Build - Stack
- `step 02-04` - Teste

### job 03 - Scan de Vunerabilidades

Esse job utiliza três steps:

- `step 03-01` - [Checkout](https://github.com/marketplace/actions/checkout)
- `step 03-02` - Build an image from Dockerfile
- `step 03-03` - [Scanear Imagem com Trivy](https://github.com/marketplace/actions/aqua-security-trivy)

### job 04 - Build e envio para o Docker Hub

Esse job utiliza sete steps:

- `step 04-01` - [Checkout](https://github.com/marketplace/actions/checkout)
- `step 04-02` - Ativa QEMU
- `step 04-03` - BuildX - Suporte remote-cache, secrets, etc...
- `step 04-04` - [Cache Docker layers](https://github.com/marketplace/actions/cache)
- `step 04-05` - [Login DockerHub](https://github.com/marketplace/actions/docker-login)
- `step 04-06` - [Build and Push](https://github.com/marketplace/actions/build-and-push-docker-images)
- `step 04-07` - Digest



## :three: - Requisitos

Informar a versão do TIKA Server através do ARG TIKA_VERSION

Necessário ter cadastrados no secrets:


 | Var | Desc |
 |:----- |-----|
 | DOCKERHUB_USERNAME  | Usuario do Docker |
 | DOCKERHUB_TOKEN  | Token do Usuario |
