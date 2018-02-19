# Docker container spec for building the develop branch of cpp-ethereum.
#
# The build process it potentially longer running but every effort was made to
# produce a very minimalistic container that can be reused many times without
# needing to constantly rebuild.
#
# This image is based on
# https://github.com/ethereum/cpp-ethereum/blob/ccac1dd777c5b25de1c0bacc72dbecb6b376689e/scripts/docker/eth-alpine/Dockerfile

FROM alpine

# Make sure bash, bc and jq is available for easier wrapper implementation
RUN apk add --no-cache \
        bash jq bc \
        python3 \
        libstdc++ \
        gmp \
        libcurl \
        libmicrohttpd \
        leveldb --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    && apk add --no-cache --virtual .build-deps \
        git \
        cmake \
        g++ \
        make \
        linux-headers curl-dev libmicrohttpd-dev \
        leveldb-dev --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    && sed -i -E -e 's|#warning|//#warning|' /usr/include/sys/poll.h \
    && git clone --recursive https://github.com/ethereum/cpp-ethereum --branch ewasm --single-branch --depth 1 \
    && cd cpp-ethereum && echo "{}"                                               \
            | jq ".+ {\"repo\":\"$(git config --get remote.origin.url)\"}" \
            | jq ".+ {\"branch\":\"$(git rev-parse --abbrev-ref HEAD)\"}"  \
            | jq ".+ {\"commit\":\"$(git rev-parse HEAD)\"}"               \
            > /version.json                                             \
    && pwd \
    && cp scripts/jsonrpcproxy.py / \
    && mkdir /build && cd /build \
    && cmake /cpp-ethereum -DHERA=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DTOOLS=Off -DTESTS=Off \
    && make eth \
    && make install \
    && cd / && rm /build -rf \
    && rm /cpp-ethereum -rf \
    && apk del .build-deps \
    && rm /var/cache/apk/* -f

# See https://github.com/ethereum/cpp-ethereum/issues/3300
# Using more than j4 can cause failures randomly

# ADD config.json /config.json

ADD ewasm-testnet-cpp-config.json /ewasm-testnet-cpp-config.json
ADD cpp-eth.sh /cpp-eth.sh

# Export the usual networking ports to allow outside access to the node
EXPOSE 8545 30303

ENTRYPOINT ["/cpp-eth.sh"]
