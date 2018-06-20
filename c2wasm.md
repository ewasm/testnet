# Compiling C to WebAssembly
Many high level languages already support compilation to WebAssembly
through the experimental LLVM backend. Unfortunately, it is a tedious
and poorly documented process. This document aims to alleviate some
of this tedium with a step-by-step tutorial to compile some basic C
code to WAST format using LLVM.

## Dependencies
- LLVM + Clang: Must be built with the experimental WASM backend enabled
- Binaryen: Needed to convert the `.s` output of LLVM's backend to WAST

## Install LLVM and Clang with the WASM backend
### Via package manager
Some package managers support package options which ease the process of
installing LLVM with special features. If you have one of these, you are in luck.
#### Portage
The only ebuilds of LLVM and Clang supporting the WASM target are the ones that checkout
the latest sources from subversion. Because they are regarded as unstable by Portage,
we must manually unmask these packages. This is done by telling portage to accept all keywords
for said packages.

Add the following lines to your `package.accept_keywords` file: 

`=sys-devel/llvm-9999 **`

`=sys-devel/clang-9999 **`

`=sys-devel/clang-runtime-9999 **`

`=sys-libs/libomp-9999 **`

`=sys-devel/clang-common-6.0.0 ~amd64`

`=sys-libs/compiler-rt-9999 **`

`=sys-libs/compiler-rt-sanitizers-9999 **`

Next we add the following USE flags to package.use:  

`>=sys-devel/llvm-5.0.1 llvm_targets_WebAssembly`

`>=sys-devel/clang-5.0.1 llvm_targets_WebAssembly`  

Note: Specifying all package atoms with a higher version than `5.0.1` just in case a stable version
releases with WASM support.

Lastly, LLVM and Clang can be emerged. Make sure that the USE flag is enabled:  
`sudo emerge -av llvm clang`

#### Other package managers
install gentoo

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
