#! /bin/bash
set -e

help () {
	echo "build.sh OPTIONS
Description:
		Local Docker development environment for the Ewasm testnet.  Creates configuration to launch a local testnet containing a miner, block explorer and smart contract development environment.
Usage:
		--geth-repo - git repository to download geth from. Default: https://github.com/ewasm/go-ethereum
		--geth-branch - branch of geth to build from. Default: ewasm
		--hera-repo - git repository to download Hera from. Default: https://github.com/ewasm/hera
		--hera-branch - branch of hera to build from. Default: master
		--etherchain-branch - branch of Etherchain light to build. Default: ewasm
		--etherchain-repo - git repository to download Etherchain light from. Default: https://github.com/ewasm/etherchain-light
		--studio-branch - branch of ewasm studio to build. Default: master
		--studio-repo - Git repository to download ewasm studio from. Default: https://github.com/ewasm/ewasm-studio
"
}

GETH_BRANCH="ewasm"
GETH_REPO="https://github.com/ewasm/go-ethereum"
HERA_BRANCH="master"
HERA_REPO="https://github.com/ewasm/hera"
ETHERCHAIN_BRANCH="ewasm"
ETHERCHAIN_REPO="https://github.com/ewasm/etherchain-light"
STUDIO_BRANCH="master"
STUDIO_REPO="https://github.com/ewasm/ewasm-studio"

while [ "$1" != "" ]; do
	case $1 in
	--help)
		help
		exit 0
		;;
	--clean)
		rm -rf go-ethereum
		rm -rf hera
		rm -rf etherchain-light
		rm -rf ewasm-studio
		;;
	--geth-branch)
		shift
		GETH_BRANCH=$1
		;;
	--geth-repo)
		shift
		GETH_REPO=$1
		;;
	--hera-branch)
		shift
		HERA_BRANCH=$1
		;;
	--hera-repo)
		shift
		HERA_REPO=$1
		;;
	--etherchain-branch)
		shift
		ETHERCHAIN_BRANCH=$1
		;;
	--etherchain-repo)
		shift
		ETHERCHAIN_REPO=$1
		;;
	--studio-branch)
		shift
		STUDIO_BRANCH=$1
		;;
	--studio-repo)
		shift
		STUDIO_REPO=$1
		;;
	-h | --help)
		help
		exit
		;;
	esac
	shift
done

( git clone $STUDIO_REPO -b $STUDIO_BRANCH && cd ewasm-studio && docker build -t ewasm/ewasm-studio . )
( git clone https://github.com/ewasm/etherchain-light -b $ETHERCHAIN_BRANCH && cd etherchain-light && docker build -t ewasm/etherchain-light . )
( git clone $HERA_REPO --recursive -b $HERA_BRANCH && cd hera && mkdir build && cmake -DBUILD_SHARED_LIBS=ON && make -j4 && cp src/libhera.so ../.. )
( git clone $GETH_REPO -b $GETH_BRANCH && cd go-ethereum && make && cp build/bin/geth .. )
docker build -t ewasm/go-ethereum .
./init-geth.sh
