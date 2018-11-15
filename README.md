# Ewasm public testnet

Welcome to the Ewasm public testnet! This repository is the primary point of coordination for the testnet. Read on for more information about how to:

- Write smart contracts in supported languages and compile them to Wasm bytecode
- Transact on the testnet, such as by deploying smart contracts compiled to Ewasm bytecode
- Run a testnet node locally
- Add a node to the testnet
- Participate in mining
- Participate in network upgrades
- Contribute to development and devops

## Background

Ewasm, which stands for Ethereum-flavored WebAssembly, is the primary candidate to replace [EVM](https://github.com/ethereum/wiki/wiki/Ethereum-Virtual-Machine-(EVM)-Awesome-List) (the Ethereum virtual machine) as part of the Ethereum 2.0 "Serenity" roadmap. It is also proposed for adoption on the Ethereum mainnet. Ewasm is a deterministic smart contract execution engine built on the modern, standard [WebAssembly virtual machine](https://webassembly.org/).

For more information on Ewasm, please refer to the following resources:

- [Ewasm background, motivation, goals, and design](https://github.com/ewasm/design)
- [The current Ewasm design spec](https://github.com/ewasm/design/blob/master/eth_interface.md)
- [CoinFund Live: Crypto Talks with Ewasm's Lane Rettig and Alex Beregszaszi](https://www.youtube.com/watch?v=gWaYnlU_pPI) (this is a high-level overview of the project's goals and current status as of 10/2018, including some helpful background on the broader Wasm ecosystem)
- [WebAssembly for Web 3.0 with Alex Beregszaszi, Peter Czaban, Sergei Shulepov & Lane Rettig](https://www.youtube.com/watch?v=H-Wz4lL3LMc) from the Web3 Summit, October 2018
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

## Writing and compiling smart contracts

### Solidity/EVM

You can deploy smart contracts written in Solidity and targeting EVM to the Ewasm testnet by using Truffle, just as you do with the Ethereum mainnet, testnets, and testrpc (Ganache). First, install [`truffle-hdwallet-provider`](https://github.com/trufflesuite/truffle-hdwallet-provider) as follows (note the specific release):

```
> npm install --save truffle-hdwallet-provider@web3-one
```

You'll want to use a `truffle.js` such as the following:

```javascript
var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    ewasm: {
      network_id: "*",
      provider: () => new HDWalletProvider("PRIVATE_KEY", "http://ewasm.ethereum.org:8545"),
    },
  }
};
```

Replace `PRIVATE_KEY` with the appropriate private key for the account you used to tap the faucet, above. After doing this, the usual truffle commands (such as `truffle migrate --network ewasm`) should work.

### Other languages

One of the [design goals](https://github.com/ewasm/design/blob/master/rationale.md) of the Ewasm project is to support smart contract development in a wide range of languages, using a range of tooling, including existing, mature toolchains such as LLVM (C/C++, Kotlin, Rust, and [many others](https://en.wikipedia.org/wiki/LLVM)) and JavaScript/TypeScript. In theory, any language that can be compiled to Wasm can be used to write a smart contract (as long as it implements the [contract interface](https://github.com/ewasm/design/blob/master/contract_interface.md) and [Ethereum interface](https://github.com/ewasm/design/blob/master/eth_interface.md)). See [awesome-wasm-langs](https://github.com/appcypher/awesome-wasm-langs) for a list of such languages.

At present, we've developed support for the following languages and toolchains:

- LLVM: C, C++, and Rust: documentation pending
- [AssemblyScript](https://github.com/AssemblyScript/assemblyscript), a subset of TypeScript, which uses the JavaScript toolchain: see the [etherts org](https://github.com/etherts/docs) for more information on writing contracts in AssemblyScript.

If you're interested in adding support for another language, framework, or toolset, see the Contributing section above and reach out.

## Differences from mainnet

The Ewasm testnet supports executing EVM 1.0 (Byzantium) bytecode **and** ewasm bytecode. The chain id is set to 0x42 (decimal 66).

There are two further technical differences:

- the code size limit introduced by Spurious Dragon has been lifted and there is no upper limit (as Wasm bytecode is more verbose than the EVM equivalent)
- zero bytes in contract bytecode are not subsidised during deployment (they cost the same as non-zero bytes)

## Transacting

You don't need any special infrastructure to transact on the Ewasm testnet. You may run your own node (see below), or you may use the public node. You may view the list of testnet tools here: http://ewasm.ethereum.org/. Start by requesting test ether from the faucet:

- Configure Metamask to use the public node. Open Metamask, tap the network selector at the top, and click Custom RPC. Enter the following URL and click Save: http://ewasm.ethereum.org:8545.
- Browse to the [faucet](http://ewasm.ethereum.org/faucet), make sure it read your public key correctly from Metamask in the "user" section, then tap "request 1 ether from faucet" in the "faucet" section.
- Click the txid that appears in the "transactions" section and watch your faucet transaction get mined.

Voila! You're now ready to transact on the testnet.

## Running a testnet node locally

The testnet currently only supports the [go-ethereum](https://github.com/ethereum/go-ethereum) (geth) client. Support for aleth (formerly, cpp-ethereum) is a work in progress and more information may be found [here](aleth.md).

## Adding a node to the testnet

### Geth

You may install and configure geth in the following ways:

- manually, from source
- using this preconfigured Docker image

#### Manual configuration

Manually configuring geth requires installing prerequisites, downloading and compiling geth from source with [EVMC](https://github.com/ethereum/evmc) support, downloading and building [Hera](https://github.com/ewasm/hera/) (the Ewasm virtual machine connector), then launching geth with Hera set as its EVMC engine.

1. Make sure the prerequisites are installed (Go version 1.7 or later, `cmake` 3.5 or later, and a C/C++ compiler).

	On CentOS-flavored Linux (e.g., Amazon Linux) you can use the following commands:

	```sh
	> sudo yum groupinstall "Development Tools"
	> wget https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.sh
	> sudo bash cmake-3.12.2-Linux-x86_64.sh --prefix=/usr/local
	> sudo yum install go
	```

	On Ubuntu/Debian-flavored system the following commands should work:

	```sh
	> sudo apt-get install build-essential make cmake golang
	```

## geth + Hera

The genesis is in [ewasm-testnet-geth-config.json](ewasm-testnet-geth-config.json)

This section describes how to run geth node with the Hera backend.

The key component to add ewasm to geth is [EVMC](https://github.com/ethereum/evmc).
Aleth supports EVMC out of the box, but geth not yet.

1. Build geth with EVMC

	Clone the [the ewasm geth fork](https://github.com/ewasm/go-ethereum):

	Geth for ewasm testnet is released regularly by tagging the above fork with `ewasm-testnet-milestoneX`, where
	`X` stands for a milestone number.

	(Latest: [`ewasm-testnet-milestone1`](https://github.com/ewasm/go-ethereum/tree/ewasm-testnet-milestone1))

	```sh
	> git clone https://github.com/ewasm/go-ethereum -b ewasm-testnet-milestone1
	> cd go-ethereum
	```

	Build geth following the official [build instructions](https://github.com/ethereum/go-ethereum#building-the-source):

	```sh
	> make geth
	```

1. Build Hera as a shared library (full build instructions [here](https://github.com/ewasm/hera#building-hera)):

	```sh
	> git clone https://github.com/ewasm/hera --recursive -b ewasm-testnet-milestone1
	> cd hera
	> mkdir build && cd build
	> cmake .. -DBUILD_SHARED_LIBS=ON
	> cmake --build .
	```

1. Download the [genesis file](ewasm-testnet-geth-config.json) and use it to initialize geth:

	```sh
	> wget https://raw.githubusercontent.com/ewasm/testnet/master/ewasm-testnet-geth-config.json
	> ./build/bin/geth --datadir /tmp/ewasm-node/4201/ init ewasm-testnet-geth-config.json
	```

	Note that the `/tmp/ewasm-node/4201` directory name above is arbitrary. It just needs to be unique.

1. Run geth with hera and connect to the testnet:

	Use `--vm.ewasm` flag in `geth` to plug in an EVMC VM shared library. Point it to the Hera shared library that you built a moment ago. 
	Additional EVMC options can be provided after a comma. 
	Hera options are documented in [hera](https://github.com/ewasm/hera).

	Note also the `--etherbase`, `--networkid`, and `--bootnodes` commands, below, and copy them verbatim as these are required to connect to and sync with the Ewasm testnet.

	The `--vmodule` argument sets the verbosity for the `eth` and `p2p` modules, which will provide lots of juicy debugging information on your node's connection to the other testnet peers, and on its mining, accepting, and propagating blocks. Feel free to reduce verbosity or turn this off.

	Finally, if you want your node to participate in mining, add the arguments `--mine --miner.threads 1`.

	Check out the geth [CLI wiki page](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) for more information on these commands, or just run `geth --help`.

	Here's the recommended configuration for connecting your node to the Ewasm testnet:

	```sh
	> ./build/bin/geth \
	--vm.ewasm="/path/to/libhera.so,metering=true,fallback=true" \
	--datadir /tmp/ewasm-node/4201/ \
	--etherbase 031159dF845ADe415202e6DA299223cb640B9DB0 \
	--rpc --rpcapi "web3,net,eth,debug" \
	--rpcvhosts="*" --rpcaddr "0.0.0.0" \
	--rpccorsdomain "*" \
	--vmodule "miner=12,rpc=12" \
	--mine --miner.threads 1 \
	--nodiscover \
	--networkid 66 \
	--bootnodes "enode://53458e6bf0353f3378e115034cf6c6039b9faed52548da9030b37b4672de4a8fd09f869c48d16f9f10937e7398ae0dbe8b9d271408da7a0cf47f42a09e662827@23.101.78.254:30303"
	```

	*NOTE*: don't forget to specify `networkId` with the same value as the value of `chainID` in the genesis configuration, this is to avoid [Metamask error `Invalid Sender`](https://github.com/MetaMask/metamask-extension/issues/3673).

	Note that if you want your node to be automatically restarted if it dies, and to survive system reboots, you'll want to use a tool such as [pm2](http://pm2.keymetrics.io/):

	```sh
	> npm install -g pm2
	```


## geth + Wagon

**NOTE: this client currently is not supported fully and the instructions here may be wrong.**

This section describes how to run geth node with the [Wagon](http://github.com/go-interpreter/wagon) VM.

1. Get the code from the PR

	```sh
	> go get github.com/ethereum/go-ethereum
	> cd $GOROOT/src/github.com/ethereum/go-ethereum
	> git remote add gballet git@github.com:gballet/go-ethereum.git
	> git fetch gballet add-ewasm
	> git checkout add-ewasm
	```

2. Build geth

	```sh
	> go build ./cmd/geth/...
	```

3. Run geth

	The ewasm interpreter will be activated by default as long as you do not specify a `--vm.ewasm=...` on the command line option.

	```sh
	> ./geth \
	--datadir /tmp/ewasm-node/4201/ \
	--etherbase 031159dF845ADe415202e6DA299223cb640B9DB0 \
	--rpc --rpcapi "web3,net,eth,debug" \
	--rpcvhosts="*" --rpcaddr "0.0.0.0" \
	--rpccorsdomain "*" \
	--mine --miner.threads 1 \
	--nodiscover \
	--networkid 66 \
	--bootnodes "enode://53458e6bf0353f3378e115034cf6c6039b9faed52548da9030b37b4672de4a8fd09f869c48d16f9f10937e7398ae0dbe8b9d271408da7a0cf47f42a09e662827@23.101.78.254:30303"
	```


### Aleth (cpp-ethereum) + Hera

**NOTE: this client currently is not supported fully and the instructions here may be wrong.**

Support for aleth (formerly, cpp-ethereum) is a work in progress and more information may be found [here](aleth.md).


### Enabling ethstats

Ethstats is a pretty UI for monitoring network state, which allows individual nodes to communicate their state to a centralized server via WebSockets. (See for instance the page for the [Ethereum mainnet](https://ethstats.net/).) Nodes must be added manually. The Ewasm team maintains an [ethstats page for the testnet](http://ewasm.ethereum.org/ethstats). If you'd like your node to be added, follow these steps:

- Make sure that you have a recent version of nodejs installed.
- Download and configure the [eth-net-intelligence-api](https://github.com/cubedro/eth-net-intelligence-api) package:

	```sh
	> git clone https://github.com/cubedro/eth-net-intelligence-api && cd eth-net-intelligence-api
	> npm install
	> NODE_ENV=production INSTANCE_NAME="Your instance name" CONTACT_DETAILS="Your contact info (optional)" WS_SERVER=wss://ewasm.ethereum.org WS_SECRET=97255273942224 VERBOSITY=2 node www/app.js
	```

You'll want to run this using `pm2` as well if you intend to keep it running long term. See the instructions for [eth-net-intelligence-api](https://github.com/cubedro/eth-net-intelligence-api), especially the [build.sh script](https://github.com/cubedro/eth-net-intelligence-api#installation-on-an-ubuntu-ec2-instance).


## Tests

Learn how to create and run ewasm tests [here](https://github.com/ewasm/tests/blob/06e0c19e117b48adcc6dd07def286d65b7e63f41/src/GeneralStateTestsFiller/stEWASMTests/README.md).

## Testnet Faucet

The faucet is a fork of the [MetaMask faucet](https://faucet.metamask.io/). The fork is maintained [here](https://github.com/ewasm/eth-faucet).
