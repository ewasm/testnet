# WebAssembly kickstart guide

## Rolling your own compiler

One of the premises of WebAssembly is to support compiling multiple languages to WebAssembly.

### C/C++

#### Building

Clang has a WebAssembly target, though it is not easy to use currently. First, a custom build must be made.

To build `clang`:
```
git clone http://llvm.org/git/llvm.git
cd llvm/tools
git clone http://llvm.org/git/clang.git
cd ../projects
git clone http://llvm.org/git/compiler-rt.git
mkdir ../build
cd ../build
cmake -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly -DLLVM_TARGETS_TO_BUILD= ..
cmake --build .
cd ../..
```

This will take anything from 1 to 5 hours.

To build `binaryen`:
```
git clone https://github.com/WebAssembly/binaryen.git
cd binaryen
mkdir build
cd build
cmake ..
cmake --build .
cd ../..
```

#### Using

Now everything is set to finally compile *Hello World*!

The compilation process has four steps:
- compiling (`clang`)
- linking to LLVM IR (`llc`)
- compiling to WebAssembly S-expressions (`s2wasm`)
- compiling to WebAssembly binary (`wasm-as`)

Note: the last step can also be accomplished with [wabt](https://github.com/webassembly/wabt) (previously called *sexpr-wasm-prototype*).

Cheat sheet:
```
clang -emit-llvm --target=wasm32 -nostdlib -S hello.c
llc -march=wasm32 -o hello.s hello.ll
s2wasm -o hello.wast hello.s
wasm-as -o hello.wasm hello.wast
```

There you go, you have your very first WebAssembly binary.

