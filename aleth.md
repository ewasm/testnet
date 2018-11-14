## Aleth (formerly cpp-ethereum)

`aleth`, `alethvm` and `testeth` contain options to run them with [Hera ewasm VM](https://github.com/ewasm/hera):

- `--vm hera` enables Hera only,
- `--evmc fallback=true` enables fallback to EVM 1.0 Interpreter when EVM bytecode is detected (off by default)

### Run Aleth + hera

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
--evmc fallback=true \
-d /tmp/ewasm-node/4201 \
--listen 4201 \
--no-bootstrap \
-m on \
-t 1 \
-a 0x031159dF845ADe415202e6DA299223cb640B9DB0 \
--config ewasm-testnet-aleth-config.json \
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
