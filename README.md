# Build da Imagem do Tika Server - Dados Abertos de Feira

[![Fluxo para construcao e publicacao do container](https://github.com/mmmarceleza/iac-docker-tika/actions/workflows/main.yml/badge.svg)](https://github.com/mmmarceleza/iac-docker-tika/actions/workflows/main.yml)

## :one: - Objetivo

Criar a imagem Docker do [Tika Server](https://cwiki.apache.org/confluence/display/TIKA/TikaServer) com as modificações necessárias para a utilização no projeto [Dados Abertos de Feira](https://www.dadosabertosdefeira.com.br) (ver [Dockerfile](https://github.com/DadosAbertosDeFeira/iac-docker-tika/blob/main/Dockerfile)). 

Será utilizada a imagem base do [Apache Tika Server](https://hub.docker.com/r/apache/tika), travada na versão [2.0.0](https://hub.docker.com/layers/apache/tika/2.0.0/images/sha256-e8e1bc87e479c9729ba14658c72162d2666eed55b0702d09555c6ff71b6a9c12?context=explore) com a instalação do pacote [tesseract-ocr-por](https://packages.debian.org/sid/graphics/tesseract-ocr-por).

Obs: outros pacotes podem ser instalados em virtude de vulnerabilidades encontradas.

## :two: - Etapas do CI

O CI usado é o próprio [GitHub Actions](https://github.com/features/actions), composto de três arquivos:

- [main.yml](https://github.com/DadosAbertosDeFeira/iac-docker-tika/blob/main/.github/workflows/main.yml)
- [scan-image-cron.yml](https://github.com/DadosAbertosDeFeira/iac-docker-tika/blob/main/.github/workflows/scan-image-cron.yml)
- [notification.yml](https://github.com/DadosAbertosDeFeira/iac-docker-tika/blob/main/.github/workflows/notification.yml)

### :page_facing_up: main.yml

O arquivo [main.yml](https://github.com/DadosAbertosDeFeira/iac-docker-tika/blob/main/.github/workflows/main.yml) é composto por quatro jobs básicos:

- `job 01` - Lint do Dockerfile
- `job 02` - Teste do container
- `job 03` - Scan da Imagem
- `job 04` - Build e envio para o Docker Hub

![fluxo-ci](img/fluxo-ci.png)

Todos as etapas estão interligadas, conforme imagem acima, de forma que o estágio seguinte só executa se o anterior concluir com sucesso. Os três primeiros executam em todo `push` e `pull request` gerado no repositório. A quarta etapa só executa na geração de [releases](https://github.com/DadosAbertosDeFeira/iac-docker-tika/releases).

#### :small_blue_diamond: job 01 - Lint do Dockerfile

Esse job utiliza dois steps:

- `step 01-01` - [Checkout](https://github.com/marketplace/actions/checkout)
- `step 01-02` - [lint](https://github.com/marketplace/actions/hadolint-action)

#### :small_blue_diamond: job 02 - Teste do container

Esse job utiliza quatro steps:

- `step 02-01` - [Checkout](https://github.com/marketplace/actions/checkout)
- `step 02-02` - [Cache Docker layers](https://github.com/marketplace/actions/cache)
- `step 02-03` - Build - Stack
- `step 02-04` - Teste

#### :small_blue_diamond: job 03 - Scan de Vunerabilidades

Esse job utiliza três steps:

- `step 03-01` - [Checkout](https://github.com/marketplace/actions/checkout)
- `step 03-02` - Build an image from Dockerfile
- `step 03-03` - [Scanear Imagem com Trivy](https://github.com/marketplace/actions/aqua-security-trivy)

#### :small_blue_diamond: job 04 - Build e envio para o Docker Hub

Esse job utiliza sete steps:

- `step 04-01` - [Checkout](https://github.com/marketplace/actions/checkout)
- `step 04-02` - Ativa QEMU
- `step 04-03` - BuildX - Suporte remote-cache, secrets, etc...
- `step 04-04` - [Cache Docker layers](https://github.com/marketplace/actions/cache)
- `step 04-05` - [Login DockerHub](https://github.com/marketplace/actions/docker-login)
- `step 04-06` - [Build and Push](https://github.com/marketplace/actions/build-and-push-docker-images)
- `step 04-07` - Digest

### :page_facing_up: scan-image-cron.yml

Este CI rodará usando o recurso do [cron](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#scheduled-events). Deste modo, foi configurado o scan da imagem uma vez por semana.
### :page_facing_up: notification.yml

Este CI também ocorrerá semanalmente, haja visto que ele é disparado com o scan semanal, conforme seção anterior. Caso o scan encontre vulnerabilidade, o job de notificação é executado e envia uma mensagem no canal do Discord da mentoria.
## :three: - Requisitos

Informar a versão do TIKA Server através do ARG TIKA_VERSION

Necessário ter cadastrados no secrets:


 | **Variável**           | **Descrição**     |
 |:---                    |---                |
 | DOCKERHUB_USERNAME     | Usuario do Docker |
 | DOCKERHUB_TOKEN        | Token do Usuario  |
 | DOCKERHUB_ORGANIZATION | nome do registry  | 
