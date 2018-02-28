#! /bin/bash

echo "printing versions.."
cat /cpp-ethereum-version.json
cat /hera-version.json


echo "running eth..."
/usr/local/bin/eth      \
  --vm hera             \
  --evmc fallback=true  \
  --db-path /tmp/ewasm-node/4201 \
  --listen 4201 \
  --no-bootstrap \
  --mining on \
  --mining-threads 1 \
  --ask 1 \
  --address 0x031159dF845ADe415202e6DA299223cb640B9DB0 \
  --config /ewasm-testnet-cpp-config.json \
  --verbosity 12 \
  &
#  --peerset "required:61e5475e6870260af84bcf61c02b2127a5c84560401452ae9c99b9ff4f0f343d65c9e26209ec32d42028b365addba27824669eb70c73f69568964f77433afbbe@127.0.0.1:1234" \


echo "running jsonrpcproxy..."
python3 /jsonrpcproxy.py /tmp/ewasm-node/4201/geth.ipc http://0.0.0.0:8545
