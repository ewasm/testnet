# Aleth (formerly cpp-ethereum)

`aleth`, `alethvm` and `testeth` contain options to run them with [Hera ewasm VM](https://github.com/ewasm/hera):

- `--vm hera` enables Hera only,
- `--evmc fallback=true` enables fallback to EVM 1.0 Interpreter when EVM bytecode is detected (off by default)

## Run Aleth + hera

The config is in [ewasm-testnet-aleth-config.json](ewasm-testnet-aleth-config.json).

Example node with mining on single CPU core, with no bootstrap:

1) Build [Hera](https://github.com/ewasm/hera) as a shared library:
```sh
> git clone https://github.com/ewasm/hera --recursive
> cd hera
> mkdir build && cd build
> cmake .. -DBUILD_SHARED_LIBS=ON
> cmake --build .
```

The shared library file is located under the `src` directory.

2) Run aleth:

```sh
> aleth \
--vm /path/to/libhera.so \
--evmc metering=true
--evmc evm1mode=fallback \
-d /tmp/ewasm-node/4201 \
--listen 4201 \
--no-bootstrap \
-m on \
-t 1 \
-a 0x031159dF845ADe415202e6DA299223cb640B9DB0 \
--config ewasm-testnet-aleth-config.json \
--peerset "required:enode://53458e6bf0353f3378e115034cf6c6039b9faed52548da9030b37b4672de4a8fd09f869c48d16f9f10937e7398ae0dbe8b9d271408da7a0cf47f42a09e662827@23.101.78.254:30303"
--log-verbosity 4
```

## JSON-RPC over HTTP

Aleth does not have the HTTP server built in, the JSON-RPC requests are served only via an Unix Socket file.
By default, the location of the socket file is `<data-dir>/geth.ipc` (yes, **geth**).

The Aleth repo includes a Python3 script called `jsonrpcproxy.py` located in [scripts/jsonrpcproxy.py](https://github.com/ethereum/aleth/blob/master/scripts/jsonrpcproxy.py).

Run it as

```sh
./jsonrpcproxy.py <data-dir>/geth.ipc
```

See `jsonrcpproxy.py --help` for more options.
