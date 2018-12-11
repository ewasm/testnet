# Writing Ewasm contracts in Rust

Rust is a modern systems programming language. 
Its type system and memory model allow for strong assumptions about memory safety at little or no runtime cost.
Furthermore, its sophisticated compiler optimizations minimize the overhead of high-level language features.

Such a combination of performance and safety lends itself to use in developing Ethereum smart contracts. 
This document serves as a comprehensive guide to using Rust in your Ewasm project.

### Assumptions

This document assumes:
* A Unix-like OS (although hopefully some of this document is applicable to Windows as well)
* The presence of a working Rust and `cargo` installation via `rustup`
* Basic familiarity with the command line, Rust, and Ethereum.

## 1. Toolchain Setup

In order to compile to WebAssembly, Rust needs the WebAssembly backend installed.

`rustup` makes this extremely simple. Just run:
```console
$ rustup target add wasm32-unknown-unknown
```
Make sure you are installing the target `wasm32-unknown-unknown` and not `wasm32-unknown-emscripten`.

## 2. Configuration and Build

Now that the WebAssembly backend is installed, it can be used to compile almost any Rust project to a Wasm binary.
However, Ewasm also specifies a set of imports and exports for contracts. These are roughly analogous to symbols in a native binary.

In order to properly export and import said symbols, the project must be compiled as a "shared library".
While this has no meaning in WebAssembly (all binaries are modules), the flag ensures that the compiler will export and import the correct symbols.

To do this, ensure that the project uses `lib.rs` as the crate root (not `main.rs`), and add the following lines to `Cargo.toml`:
```toml
[lib]
crate-type = ["cdylib"]
```
Compile the project using the `--target` flag:
```console
$ cargo build --target=wasm32-unknown-unknown
```
Alternatively, to set WebAssembly as a default target, one can specify it in `.cargo/config`. 
Create a `.cargo` directory in the project root, if it does not exist already:
```console
$ mkdir .cargo
```
Proceed to create or modify `.cargo/config` and add the following:
```toml
[build]
target = "wasm32-unknown-unknown"
```
Once this is done, `cargo build` will compile the project to WebAssembly by default.

### Optimizing Ewasm binaries

By default, the Rust compiler can generate huge WebAssembly binaries, even in release mode. 
These are not suitable for use as Ewasm contracts, and include lots of unnecessary cruft.

The following steps will show how to optimize for size and remove unnecessary code segments from the resulting Wasm binary.

#### Compiler optimizations

The simplest way to slim down Rust-generated binaries is by enabling certain compiler optimizations:

* Enabling `lto`, or link-time optimizations, allows the compiler to prune or inline parts of the code at link-time.
* Setting `opt-level` to `'s'` tells the compiler to optimize for binary size rather than speed. `opt-level = 'z'` will optimize more aggressively for size, although at the cost of performance.

Enable these options in the `release` profile by adding the following to `Cargo.toml`.
```toml
[profile.release]
lto = true
opt-level = 's'
```

#### Using [wasm-snip](https://github.com/rustwasm/wasm-snip)

The Rust compiler, by default, includes panicking and formatting code in generated binaries. For the purpose of Ewasm contracts, this is useless.
Using the `wasm-snip` tool, it is possible to replace the function bodies of such code with a single `unreachable` opcode, further shrinking the binary size.

`wasm-snip` can be easily installed using `cargo`:
```console
$ cargo install wasm-snip
```
`wasm-snip` depends on the name section in the Wasm binary being present. Therefore, we must build with `debug` enabled. Add the following to the `[profile.release]` section in `Cargo.toml`:
```toml
debug = true
```
After build, run `wasm-snip` on the resulting binary. It should be located in `target/wasm32-unknown-unknown/release`:
```console
$ wasm-snip --snip-rust-panicking-code --snip-rust-fmt-code input.wasm -o output.wasm
```

## 3. Writing Ewasm contracts

The Ewasm specification, in addition to the normal constraints of the blockchain, makes writing code for Ewasm contracts a little different from writing plain Rust.

The following is a list of rules and best practices for writing Ewasm contracts.

### `lib.rs`, not `main.rs`

As stated earlier, using `main.rs` as a crate root will produce an executable rather than a library.

### Export `main`

Every Ewasm contract is required to export a `main` function as the main entry point for execution. In Rust, simply add the `pub` and `extern "C"` qualifiers to do this:
```rust
#[no_mangle]
pub extern "C" fn main() {
	// function body goes here
}
```
The `no_mangle` directive should be included as well, to ensure that the compiler will not mangle the `main` identifier and invalidate it.

### Use `finish` and `revert` to end execution

When writing code for a native platform, ending execution properly is usually handled behind the scenes. In Ewasm, there are two EEI functions that signal to end execution:

* `finish` behaves like EVM's `return`. Simply put, it sets the output data and halts the VM.
* `revert` is the exact same thing as EVM's `revert`. It halts the VM and refunds any gas.

### Minimize the use of the standard library

Many constructs in Rust's standard library are not optimized for usage in Ewasm, or are outright unavailable due to dependence on a native syscall interface.

Minimizing the use of non-primitive standard library constructs will improve the size, performance, and gas efficiency of resulting Wasm binaries. Where possible, follow these rules of thumb:
* Minimize the usage of the heap, in general. Don't use `Box<T>` or `Rc<T>`, or any other smart pointers.
* Avoid using types with implicitly heap-allocated data. Use arrays instead of `Vec`, and `str` instead of `String`.
* Borrowing is your friend. Stop using `clone()` and passing non-trivial structs by value, use lifetime parameters and references instead.

### Use the [ewasm-rust-api](https://github.com/ewasm/ewasm-rust-api)

The `ewasm-rust-api` is a convenient library providing safe wrappers around the native EEI functions, in addition to a set of useful EVM-style types.

To use it in your contract, simply add `ewasm_api` as a dependency to `Cargo.toml` and include it in your project.

## 4. Deploying Ewasm contracts

There is one final step that must be done before contract creation: post-processing. 

The Rust compiler, at the moment, does not have fine-grained control over the imports and exports generated other than by their identifiers in the source. As a result, unnecessary exports must be removed and malformed imports corrected.

This can be done using an automated tool such as [wasm-chisel](https://github.com/wasmx/wasm-chisel), or by hand in the `.wast` file produced by disassembling the Wasm binary.

If done by hand, the most common errors will be import names being prefixed with `ethereum_` and globals or tables being unnecessarily exported.
