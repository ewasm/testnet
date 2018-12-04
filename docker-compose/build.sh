#! /bin/bash
set -e
( git clone https://github.com/ewasm/ewasm-studio && cd ewasm-studio && docker build -t ewasm/ewasm-studio . )
( git clone https://github.com/ewasm/etherchain-light && cd etherchain-light && docker build -t ewasm/etherchain-light . )
docker build -t ewasm/go-ethereum .
