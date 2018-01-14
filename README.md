# ewasm testnet coordination / documentation repo

## cpp-ethereum

To build cpp-ethereum with the recent eWASM changes use [ewasm-sprint](https://github.com/ethereum/cpp-ethereum/tree/ewasm-sprint). 

The `eth`, `ethvm` and `testeth` contain options to run them with [Hera eWASM VM](https://github.com/ewasm/hera):

- `--vm hera` enables Hera only,
- `--vm heraplus` enables Hera with a fallback to EVM 1.0 Interpreter when EVM bytecode is detected. 

## Tests

Track the progress of EEI test implementation [here](https://github.com/ethereum/tests/pull/394)
