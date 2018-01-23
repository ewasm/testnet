# ewasm testnet coordination / documentation repo

## cpp-ethereum

To build cpp-ethereum with the recent eWASM changes use [ewasm](https://github.com/ethereum/cpp-ethereum/tree/ewasm).

The `eth`, `ethvm` and `testeth` contain options to run them with [Hera eWASM VM](https://github.com/ewasm/hera):

- `--vm hera` enables Hera only,
- `--evmc fallback=true` enables fallback to EVM 1.0 Interpreter when EVM bytecode is detected.

### Test net differences from main net

Supports executing EVM 1.0 (Byzantium) **and** eWASM bytecode. The chain id is set to 0x42 (66).

There are two differences:
- code size limit introduced by Spurious Dragon has been lifted and there is no upper limit
- zero bytes in contract bytecode are not subsidised anymore during deployment (they cost the same as non-zero bytes)

### Run eth node

The config is in [ewasm-testnet-cpp-config.json](ewasm-testnet-cpp-config.json).

Example node with mining on single CPU core, with no bootstrap:

```sh
eth \
--vm hera \
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

The cpp-ethereum (eth) does not have the HTTP server built in, the JSON-RPC requests are served only via an Unix Socket file.
By default, the location of the socket file is `<data-dir>/geth.ipc` (yes, **geth**).

The cpp-ethereum repo includes a Python3 script called jsonrpcproxy.py located in [scripts/jsonrpcproxy.py](https://github.com/ethereum/cpp-ethereum/blob/develop/scripts/jsonrpcproxy.py).

Run it as

```sh
./jsonrpcproxy.py <data-dir>/geth.ipc
```

See `jsonrcpproxy.py --help` for more options.

## Tests

Track the progress of EEI test implementation [here](https://github.com/ethereum/tests/pull/394)
