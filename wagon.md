# geth + Wagon

**NOTE: this client currently is not supported fully and the instructions here may be wrong.**

[Wagon](http://github.com/go-interpreter/wagon) is a third-party WebAssembly VM written natively in Go. Support for geth + Wagon on the Ewasm testnet is experimental. This document describes how to run geth node with geth and the Wagon VM.

1. Get the code from the PR

	```sh
	> go get github.com/ethereum/go-ethereum
	> cd $GOROOT/src/github.com/ethereum/go-ethereum
	> git remote add gballet git@github.com:gballet/go-ethereum.git
	> git fetch gballet add-ewasm
	> git checkout add-ewasm
	```

1. Build geth

	```sh
	> go build ./cmd/geth/...
	```

1. Run geth

	The Ewasm interpreter will be activated by default as long as you do not specify a `--vm.ewasm=...` on the command line option.

	```sh
	> TMPDIR=/tmp/ewasm-node/ ./geth --datadir $TMPDIR --etherbase 031159dF845ADe415202e6DA299223cb640B9DB0 --rpc --rpcapi "web3,net,eth,debug" --rpcvhosts="*" --rpcaddr "0.0.0.0" --rpccorsdomain "*" --mine --miner.threads 1 --nodiscover --networkid 66
	```
