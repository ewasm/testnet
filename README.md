# Ewasm public testnet

Welcome to the Ewasm public testnet! This repository is the primary point of coordination for the testnet. Read on for more information about how to:

- Transact on the testnet, such as by deploying smart contracts compiled to Ewasm bytecode
- Add a node to the testnet
- Participate in mining
- Participate in network forks
- Contribute to development and devops

## Background

Ewasm, which stands for Ethereum-flavored WebAssembly, is the primary candidate to replace EVM (the Ethereum virtual machine) as part of the Ethereum 2.0 "Shasper" roadmap. It is also proposed for adoption on the Ethereum mainnet. Ewasm is a deterministic smart contract execution engine built on the modern, standard [WebAssembly virtual machine](https://webassembly.org/).

For more information on Ewasm, please refer to the following resources:

- [Ewasm background, motivation, goals, and design](https://github.com/ewasm/design)
- [The current Ewasm design spec](https://github.com/ewasm/design/blob/master/eth_interface.md)
- [Latest Ewasm community call including live demo of the testnet](https://www.youtube.com/watch?v=apIHpBSdBio)
- [Why eWASM? by Alex Beregszaszi (@axic)](https://www.youtube.com/watch?v=VF7f_s2P3U0)
- [Panel: entire eWASM team discussion and Q&A](https://youtu.be/ThvForkdPyc?t=119)
- [Ewasm community meetup at ETHBuenosAires](https://www.youtube.com/watch?v=qDzrbj7dtyU)

## Contributing

The primary communication channels for the Ewasm project are GitHub and Gitter.

- You may log issues in this repository with questions about the testnet
- You may make contributions to this repository as pull requests
- Join the [public Ewasm chatroom on Gitter](https://gitter.im/ewasm/Lobby)

The team also hosts a (roughly) fortnightly public "Ewasm community hangout" call. Look for the the next scheduled call in [ewasm/pm issues](https://github.com/ewasm/pm/issues). Calls are announced, including dial-in information, in [ewasm/Lobby](https://gitter.im/ewasm/Lobby). Calls are also livestreamed and recorded.

## Transacting

You don't need any special infrastructure to transact on the Ewasm testnet. You may run your own node (see below), or you may use the public node. You may view the list of testnet tools here: http://<TESTNET_URL>/. Start by requesting test ether from the faucet:

- Configure Metamask to use the public node. Open Metamask, tap the network selector at the top, and click Custom RPC. Enter the following URL and click Save: http://<TESTNET_URL>:8545.
- Browse to the [faucet](http://<TESTNET_URL>/faucet), make sure it read your public key correctly from Metamask in the "user" section, then tap "request 1 ether from faucet" in the "faucet" section.
- Open the [testnet explorer](http://<TESTNET_URL>/explorer/) and watch your faucet transaction get mined.

Voila! You're now ready to transact on the testnet.

## Differences from mainnet

The Ewasm testnet supports executing EVM 1.0 (Byzantium) bytecode **and** ewasm bytecode. The chain id is set to 0x42 (66).

There are two differences:
- code size limit introduced by Spurious Dragon has been lifted and there is no upper limit
- zero bytes in contract bytecode are not subsidised anymore during deployment (they cost the same as non-zero bytes)

## Adding a node to the testnet

The testnet currently only supports the [go-ethereum](https://github.com/ethereum/go-ethereum) (geth) client. Support for aleth (formerly, cpp-ethereum) is a work in progress and more information may be found [here](aleth.md).

### Geth

You may install and configfure geth in the following ways:

- manually, from source
- using this preconfigured Docker image

#### Manual configuration

Manually configuring geth requires installing prerequisites, downloading and compiling geth from source with [EVMC](https://github.com/ethereum/evmc) support, downloading and building [hera](https://github.com/ewasm/hera/) (the Ewasm virtual machine connector), then launching geth with hera set as its EVMC engine.

1. Make sure the prerequisites are installed (Go version 1.7 or later, `cmake`, and a C compiler).

	On CentOS-flavored Linux (e.g., Amazon Linux) you can use the following commands:
	
	```sh
	> sudo yum groupinstall "Development Tools"
	> wget https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.sh
	> sudo bash cmake-3.12.2-Linux-x86_64.sh --prefix=/usr/local
	> sudo yum install go
	```

1. Build geth with EVMC:

	Checkout the `evmc` branch of [this geth fork](https://github.com/chfast/go-ethereum/tree/evmc):
	
	```sh
	> git clone https://github.com/chfast/go-ethereum && cd go-ethereum
	> git checkout evmc
	```
	
	Build geth following the official [build instructions](https://github.com/ethereum/go-ethereum#building-the-source):
	
	```sh
	> make geth
	```

- `--vm hera` enables Hera only,
- `--evmc fallback=true` enables fallback to EVM 1.0 Interpreter when EVM bytecode is detected (off by default)

### Run eth node

The config is in [ewasm-testnet-cpp-config.json](ewasm-testnet-cpp-config.json).

Example node with mining on single CPU core, with no bootstrap:

1) Build (hera)[https://github.com/ewasm/hera] as a shared library:
```
git clone https://github.com/ewasm/hera --recursive
cd hera
mkdir build && cd build
cmake .. -DBUILD_SHARED_LIBS=ON
cmake --build .
```
The shared library file is located under the `src` directory.

2) Run aleth:
```sh
aleth \
--vm /path/to/libhera.so \
--evmc fallback=true \
-d /tmp/ewasm-node/4201 \
--listen 4201 \
--no-bootstrap \
-m on \
-t 1 \
-a 0x031159dF845ADe415202e6DA299223cb640B9DB0 \
--config ewasm-testnet-cpp-config.json \
--peerset "required:61e5475e6870260af84bcf61c02b2127a5c84560401452ae9c99b9ff4f0f343d65c9e26209ec32d42028b365addba27824669eb70c73f69568964f77433afbbe@127.0.0.1:1234"
```

### JSON-RPC over HTTP

Aleth does not have the HTTP server built in, the JSON-RPC requests are served only via an Unix Socket file.
By default, the location of the socket file is `<data-dir>/geth.ipc` (yes, **geth**).

The Aleth repo includes a Python3 script called `jsonrpcproxy.py` located in [scripts/jsonrpcproxy.py](https://github.com/ethereum/aleth/blob/master/scripts/jsonrpcproxy.py).

Run it as

```sh
./jsonrpcproxy.py <data-dir>/geth.ipc
```

See `jsonrcpproxy.py --help` for more options.


## geth + Hera

The config is in [ewasm-testnet-geth-config.json](ewasm-testnet-geth-config.json)

This section describes how to run geth node with ewasm backend.

The key component to add ewasm to geth is [EVMC](https://github.com/ethereum/evmc).
Hera supports EVMC out of the box, but geth not yet.

1. Build geth with EVMC

	Checkout `evmc` branch of go-ethereum fork https://github.com/chfast/go-ethereum/tree/evmc ([PR](https://github.com/ethereum/go-ethereum/pull/17050)).
	Build geth following official [build instructions](https://github.com/ethereum/go-ethereum#building-the-source).

2. Build hera as a shared library:

	```sh
	> cd
	> git clone https://github.com/ewasm/hera && cd hera
	> mkdir build && cd build
	> cmake .. -DBUILD_SHARED_LIBS=ON
	> cmake --build .
	```
	
	Note: if you get an error about `No rule to make target 'deps/lib/libbinaryen.a'`, see workaround [here](https://github.com/ewasm/hera/issues/431).

1. Download the [genesis file](ewasm-geth-genesis.json) and use it to initialize geth:

	```sh
	> wget https://raw.githubusercontent.com/ewasm/testnet/master/ewasm-testnet-geth-genesis.json
	> ./build/bin/geth --datadir /tmp/ewasm-node/4201/ init ewasm-testnet-geth-genesis.json
	```
	
	Note that the `/tmp/ewasm-node/4201` directory name above is arbitrary. It just needs to be unique.

1. Run geth with hera and connect to the testnet:

	`geth` will check the `EVMC_PATH` environment variable for path to EVMC VM shared library. Point it to the hera shared library that you built a moment ago. Additionally `geth` will check the `EVMC_OPTIONS` environment variable for EVMC options (which are documented in [hera](https://github.com/ewasm/hera)). Multiple options can be specified by separating them with a space, e.g., `EVMC_OPTIONS='metering=true fallback=true'`.
	
	Note also the `--etherbase`, `--networkid`, and `--bootnodes` commands, below, and copy them verbatim as these are required to connect to and sync with the Ewasm testnet.
	
	The `--vmodule` argument sets the verbosity for the `eth` and `p2p` modules, which will provide lots of juicy debugging information on your node's connection to the other testnet peers, and on its mining, accepting, and propagating blocks. Feel free to reduce verbosity or turn this off.
	
	Finally, if you want your node to participate in mining, add the arguments `--mine --miner.threads 1`.
	
	Check out the geth [CLI wiki page](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) for more information on these commands, or just run `geth --help`.
	
	Here's the recommended configuration for connecting your node to the Ewasm testnet:

	```sh
	> EVMC_PATH=~/hera/build/src/libhera.so EVMC_OPTIONS='metering=true fallback=true' \
	./build/bin/geth \
	--etherbase a8c3eeb2915373139bcfc287d4ae9e660d734881 \
	--rpc --rpcapi "web3,net,eth,debug" --rpcvhosts=* --rpcaddr "0.0.0.0" --rpccorsdomain "*" \
	--vmodule "eth=12,p2p=12" \
	--networkid 66 \
	--bootnodes "enode://2a4115eb2ab97eea00759d1edcb53d06efa5edc0d7272b4be73ddec49667a6f078278c62aacfb1d44df4d25c04c99d39f02d430ae2dd070891218d6cd121bc8e@40.114.204.83:30303"
	```
	
	Note that if you want your node to be automatically restarted if it dies, and to survive system reboots, you'll want to use a tool such as [pm2](http://pm2.keymetrics.io/):
	
	```sh
	> npm install -g pm2
	```

    Initialize the geth node prior to starting up to ensure all blockchain parameters are correctly set:
    
    ```sh
    ./build/bin/geth --datadir /tmp/ewasm-node/4201/ init ewasm-testnet-geth-config.json
    ```
    
	Run the built geth with configuration for ewasm testnet.

	```sh
	./build/bin/geth --datadir /tmp/ewasm-node/4201/ --etherbase 031159dF845ADe415202e6DA299223cb640B9DB0 --rpc --rpcapi "web3,net,eth,debug" --rpcvhosts="*" --rpcaddr "0.0.0.0" --rpccorsdomain "*" --vmodule "miner=12,rpc=12" --mine --miner.threads 1 --nodiscover --networkid 66 
	```
    *NOTE*: don't forget to specify `networkId` with the same value as the value of `chainID` in the genesis configuration, this is to avoid [Metamask error `Invalid Sender`](https://github.com/MetaMask/metamask-extension/issues/3673).
1. Enabling ethstats:

	Ethstats is a pretty UI for monitoring network state, which allows individual nodes to communicate their state to a centralized server via WebSockets. (See for instance the page for the [Ethereum mainnet](https://ethstats.net/).) Nodes must be added manually. The Ewasm team maintains an [ethstats page for the testnet](http://testnet.ewasmile.ch:3000/). If you'd like your node to be added, follow these steps:
	
	- Make sure that you have a recent version of nodejs installed.
	- Download and configure the [eth-net-intelligence-api](https://github.com/cubedro/eth-net-intelligence-api) package:
	
	```sh
	> git clone https://github.com/cubedro/eth-net-intelligence-api && cd eth-net-intelligence-api
	> npm install
	> NODE_ENV=production INSTANCE_NAME="Your instance name" CONTACT_DETAILS="Your contact info (optional)" WS_SERVER=wss://testnet.ewasmile.ch WS_SECRET=97255273942224 VERBOSITY=2 node www/app.js
	```
	
	You'll want to run this using `pm2` as well if you intend to keep it running long term. See the instructions for [eth-net-intelligence-api](https://github.com/cubedro/eth-net-intelligence-api), especially the [build.sh script](https://github.com/cubedro/eth-net-intelligence-api#installation-on-an-ubuntu-ec2-instance).

#### Docker configuration

## Tests

Learn how to create and run ewasm tests [here](https://github.com/ewasm/tests/blob/06e0c19e117b48adcc6dd07def286d65b7e63f41/src/GeneralStateTestsFiller/stEWASMTests/README.md).

## Testnet Faucet

It is a fork of the [MetaMask faucet](https://faucet.metamask.io/). The fork is maintained [here](https://github.com/ewasm/eth-faucet).
