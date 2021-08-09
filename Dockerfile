FROM debian:stable-20210721 AS builder

WORKDIR /opt/builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg

ARG VERSION=0.18.1

# https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt
RUN set -eux && \
    gpg --keyserver keyserver.ubuntu.com --recv-key FE3348877809386C && \
    gpg --fingerprint FE3348877809386C && \
    curl -sSfO https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-x86_64-linux-gnu.tar.gz && \
    curl -sSfO https://download.litecoin.org/litecoin-${VERSION}/linux/litecoin-${VERSION}-linux-signatures.asc && \
    gpg --verify litecoin-${VERSION}-linux-signatures.asc && \
    grep litecoin-${VERSION}-x86_64-linux-gnu.tar.gz  litecoin-${VERSION}-linux-signatures.asc | sha256sum -c --status && \
    tar -zxvf litecoin-${VERSION}-x86_64-linux-gnu.tar.gz


FROM debian:stable-20210721-slim

WORKDIR /opt/litecoin

ARG VERSION=0.18.1
RUN useradd -m -u 10001 -U -s /usr/sbin/nologin litecoin

USER litecoin
COPY --chown=litecoin:litecoin --from=builder /opt/builder/litecoin-${VERSION}/bin/litecoind .

# https://litecoin.info/index.php/Litecoin.conf
EXPOSE 9333

ENTRYPOINT [ "/opt/litecoin/litecoind" ]