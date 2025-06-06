FROM debian:stable-slim

ARG BITCOIN_VERSION
ENV PATH=/opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH

RUN apt-get update -y \
  && apt-get install -y curl ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG USERID=1000
ARG GROUPID=1000
RUN groupadd -g $GROUPID bitcoin && \
  useradd -u $USERID -g bitcoin -m -s /bin/bash bitcoin

RUN SYS_ARCH="$(uname -m)" \
  && curl -SLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-${SYS_ARCH}-linux-gnu.tar.gz \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz

COPY bitcoin.conf /home/bitcoin/.bitcoin/bitcoin.conf

RUN chown -R bitcoin:bitcoin /home/bitcoin

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 38333 18443 38334

USER bitcoin
WORKDIR /home/bitcoin
