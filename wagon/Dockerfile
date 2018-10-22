# Build Geth in a stock Go builder container
FROM golang:1.11-alpine

RUN apk add --no-cache make gcc musl-dev linux-headers git
RUN go get github.com/ethereum/go-ethereum
RUN cd /go/src/github.com/ethereum/go-ethereum && \
    git remote add moi http://github.com/gballet/go-ethereum && \
    git fetch moi && \
    git checkout add-ewasm && \
    go build -o geth+wagon ./cmd/geth/...
ADD ./testnet-genesis.json /go/src/github.com/ethereum/go-ethereum/genesis.json
RUN cd /go/src/github.com/ethereum/go-ethereum && \
    ./geth+wagon init genesis.json

CMD ["/go/src/github.com/ethereum/go-ethereum/geth+wagon", "--etherbase", "a8c3eeb2915373139bcfc287d4ae9e660d734881", "--rpc", "--rpcapi", "web3,net,eth,debug", "--rpcvhosts=*", "--rpcaddr", "0.0.0.0", "--rpccorsdomain", "*", "--vmodule", "eth=12,p2p=12", "--networkid", "66", "--bootnodes", "enode://53458e6bf0353f3378e115034cf6c6039b9faed52548da9030b37b4672de4a8fd09f869c48d16f9f10937e7398ae0dbe8b9d271408da7a0cf47f42a09e662827@40.114.200.106:30303", "--vm.ewasm", "metering:true"]

EXPOSE 8545 8546 30303 30303/udp
