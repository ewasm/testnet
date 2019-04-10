#! /bin/bash

rm -rf hera libhera.so && mkdir hera
rm -f hera-0.2.3-alpha.0-linux-x86_64.tar.gz
rm -f geth v1.9.0-evmc.6.1.1-0-unstable.tar.gz go-ethereum-1.9.0-evmc.6.1.1-0-unstable

wget https://github.com/ewasm/hera/releases/download/v0.2.3-alpha.0/hera-0.2.3-alpha.0-linux-x86_64.tar.gz && tar -C hera -xvf hera-0.2.3-alpha.0-linux-x86_64.tar.gz
cp hera/lib/libhera.so .

wget https://github.com/ewasm/go-ethereum/archive/v1.9.0-evmc.6.1.1-0-unstable.tar.gz && tar -xvf v1.9.0-evmc.6.1.1-0-unstable.tar.gz
(cd go-ethereum-1.9.0-evmc.6.1.1-0-unstable && make && mv build/bin/geth ..)

docker build -t ewasm/geth-hera .
./init-geth.sh
