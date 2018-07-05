# Compiling C to WebAssembly
Many high level languages already support compilation to WebAssembly
through the experimental LLVM backend. Unfortunately, it is a tedious
and poorly documented process. This document aims to alleviate some
of this tedium with a step-by-step tutorial to compile some basic C
code to WAST format using LLVM, as well as provide instructions for building
the toolchain.

## Dependencies
- LLVM + Clang: Must be built with the experimental WASM backend enabled
- Binaryen: Needed to convert the `.s` output of LLVM's backend to WAST

## Install LLVM and Clang with the WASM backend

### From the repo
First, clone the needed repositories:  

`git clone http://llvm.org/git/llvm.git`

`cd llvm/tools`

`git clone http://llvm.org/git/clang.git`

`cd ../projects`

`git clone http://llvm.org/git/compiler-rt.git`

Then initialize CMake:  

`mkdir ../build`

`cd ../build`

`cmake -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly -DLLVM_TARGETS_TO_BUILD= ..`

Lastly, call `make` as usual:  

`make -j4 all`  

At the end of the (long) build the binaries will be in `bin`. Feel free to add that to your `PATH` for ease of use.

## Install Binaryen
This one is much easier. Simply:

`git clone https://github.com/WebAssembly/binaryen.git`

`cd binaryen` 

`mkdir build`

`cd build`  

`cmake ..` 

`make -j4 all`  

CMake will also generate an `install` target if you want to actually install Binaryen on your system.

## Compile C to WASM
First we must compile C to LLVM bitcode through the Clang frontend:  

`clang -emit-llvm --target=wasm32-unknown-unknown-elf -c -o source.bc source.c`  

Next we can generate WASM output from the bitcode:  

`llc -asm-verbose=false -o main.s main.bc`  

The backend output is in linear WASM format so we must convert this to WAST with binaryen's `s2wasm` tool:  

`s2wasm -o main.wast main.s`  

The code will now be in WAST format but must be cleaned up with `ewasm-cleanup` to be deployed as a contract.  
