#! /bin/bash
set -e
( git clone https://github.com/ewasm/ewasm-studio && cd ewasm-studio && docker build -t ewasm/ewasm-studio . )
( git clone https://github.com/ewasm/etherchain-light && cd etherchain-light && docker build -t ewasm/etherchain-light . )
( git clone https://github.com/ewasm/hera --recursive && cd hera && cmake -DBUILD_SHARED_LIBS=ON && make -j4 && cp src/libhera.so .. )
( git clone https://github.com/ewasm/go-ethereum && cd go-ethereum && make && cp build/bin/geth .. )
docker build -t ewasm/go-ethereum .
./init-geth.sh
