# ewasm testnet coordination / documentation repo

## Aleth (ex cpp-ethereum)

To build Aleth with the recent ewasm changes use [ewasm](https://github.com/ethereum/aleth/tree/ewasm).

`aleth`, `alethvm` and `testeth` contain options to run them with [Hera ewasm VM](https://github.com/ewasm/hera):

- `--vm hera` enables Hera only,
- `--evmc fallback=true` enables fallback to EVM 1.0 Interpreter when EVM bytecode is detected (off by default)

### Test net differences from main net

Supports executing EVM 1.0 (Byzantium) **and** ewasm bytecode. The chain id is set to 0x42 (66).

There are two differences:
- code size limit introduced by Spurious Dragon has been lifted and there is no upper limit
- zero bytes in contract bytecode are not subsidised anymore during deployment (they cost the same as non-zero bytes)

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

This section describes how to run geth node with ewasm backend.

The key component to add ewasm to geth is [EVMC](https://github.com/ethereum/evmc).
Hera supports EVMC out of the box, but geth not yet.

1. Build geth with EVMC

	Checkout `evmc` branch of go-ethereum fork https://github.com/chfast/go-ethereum/tree/evmc ([PR](https://github.com/ethereum/go-ethereum/pull/17050)).
	Build geth following official [build instructions](https://github.com/ethereum/go-ethereum#building-the-source).

2. Build Hera to shared library

	```sh
	mkdir build && cd build
	cmake .. -DBUILD_SHARED_LIBS=ON
	cmake --build .
	```

3. Run geth with Hera

	geth will check the `EVMC_PATH` environment variable for path to EVMC VM shared library. Point it to Hera shared library.

	```sh
	export EVMC_PATH=~/hera/build/src/libhera.so
	```

	Additionally `geth` will check the `EVMC_OPTIONS` environment variable for EVMC options. Multiple options can be specified by separating them with a space:

	```sh
	export EVMC_OPTIONS='metering=true fallback=true'
	```

	Run the built geth with configuration for ewasm testnet.

	```sh
	build/bin/geth
	```


## Tests

Learn how to create and run ewasm tests [here](https://github.com/ewasm/tests/blob/06e0c19e117b48adcc6dd07def286d65b7e63f41/src/GeneralStateTestsFiller/stEWASMTests/README.md).

## Testnet Faucet

It is a fork of the [MetaMask faucet](https://faucet.metamask.io/). The fork is maintained [here](https://github.com/ewasm/eth-faucet).
