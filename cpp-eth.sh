#! /bin/bash

echo "printing versions.."
# cat /cpp-ethereum-version.json
# cat /hera-version.json

PEER_1="enode://a604159cad54b3136812fd19c1656a035f6070e27fc3ab433bc04b61fb2c1a27f6563a53b80c88e2453b6b059bd7658e59ebbbb60de8d09ae9b78fce8e84887b@miner1:30303"
PEER_2="enode://eb085e5795760a7aa83026b56c433ba3b027738eed2cbf4ebad6ccf0ca3ccd78369f4ffa77b59f763e31a41245980d246c2e0acb6362785a9ec21824385cf87b@miner2:30303"
PEER_3="enode://37ffd11745b7243a0e835cae086be8e20b4ace08d5ce38d4d65ac9149e4fbe96a1a00c2df3090a9a858d6a1bf389cb5f7d012f3435ff4b8253ad22414c9da153@miner3:30303"

PEER_SET=""

if [ "$NODE_NUM" == "1" ] 
then
  PEER_SET="$PEER_2 $PEER_3"
  cp /enodes/a604159cad54b3136812fd19c1656a035f6070e27fc3ab433bc04b61fb2c1a27f6563a53b80c88e2453b6b059bd7658e59ebbbb60de8d09ae9b78fce8e84887b/* /tmp/ewasm-node/4201/
  echo "foobar1"
fi

if [ "$NODE_NUM" == "2" ] 
then
  PEER_SET="$PEER_1 $PEER_3"
  cp /enodes/eb085e5795760a7aa83026b56c433ba3b027738eed2cbf4ebad6ccf0ca3ccd78369f4ffa77b59f763e31a41245980d246c2e0acb6362785a9ec21824385cf87b/* /tmp/ewasm-node/4201/
  echo "foobar2"
fi

if [ "$NODE_NUM" == "3" ] 
then
  PEER_SET="$PEER_1 $PEER_2"
  cp /enodes/37ffd11745b7243a0e835cae086be8e20b4ace08d5ce38d4d65ac9149e4fbe96a1a00c2df3090a9a858d6a1bf389cb5f7d012f3435ff4b8253ad22414c9da153/* /tmp/ewasm-node/4201/
  echo "foobar3"
fi

echo $PEER_SET

echo "running eth..."
eth \
  --vm /libhera.so \
  --evmc fallback=true  \
  --db-path /tmp/ewasm-node/4201 \
  --no-bootstrap \
  --mining on \
  --mining-threads 1 \
  --ask 1 \
  --address 0x031159dF845ADe415202e6DA299223cb640B9DB0 \
  --config /ewasm-testnet-cpp-config.json \
  --listen 1234 &
  --peerset "$PEER_SET"
  # &

#  --peerset "required:61e5475e6870260af84bcf61c02b2127a5c84560401452ae9c99b9ff4f0f343d65c9e26209ec32d42028b365addba27824669eb70c73f69568964f77433afbbe@127.0.0.1:1234" \


echo "running jsonrpcproxy..."
python3 /jsonrpcproxy.py /tmp/ewasm-node/4201/geth.ipc
