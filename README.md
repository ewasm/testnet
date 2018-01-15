# ewasm testnet coordination / documentation repo

## cpp-ethereum

To build cpp-ethereum with the recent eWASM changes use [ewasm-sprint](https://github.com/ethereum/cpp-ethereum/tree/ewasm-sprint).

The `eth`, `ethvm` and `testeth` contain options to run them with [Hera eWASM VM](https://github.com/ewasm/hera):

- `--vm hera` enables Hera only,
- `--vm heraplus` enables Hera with a fallback to EVM 1.0 Interpreter when EVM bytecode is detected.

### Run eth node

The config is in [ewasm-testnet-cpp-config.json](ewasm-testnet-cpp-config.json).

Example node with mining on single CPU core, with no bootstrap:

```sh
eth \
--vm heraplus \
-d /tmp/ewasm-node/4201 \
--listen 4201 \
--no-bootstrap \
-m on \
-t 1 \
-a 0x031159dF845ADe415202e6DA299223cb640B9DB0 \
--config ewasm-testnet-cpp-config.json \
--peerset "required:61e5475e6870260af84bcf61c02b2127a5c84560401452ae9c99b9ff4f0f343d65c9e26209ec32d42028b365addba27824669eb70c73f69568964f77433afbbe@127.0.0.1:1234"
```

## Tests

Track the progress of EEI test implementation [here](https://github.com/ethereum/tests/pull/394)
