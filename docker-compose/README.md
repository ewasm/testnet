# ewasm Testnet Local Configuration
## Setup
* build go-ethereum, build hera with shared lib mode
* copy geth binary and libhera.so to this folder
* execute `build.sh` to build docker images for etherchain-light, ewasm-studio and geth
* spin up all components `docker-compose up`

## Components
* Geth - 172.28.0.2
* Explorer - 172.28.0.3:3000
* Ewasm Studio - 172.28.0.4
