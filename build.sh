#!/bin/bash

# config

export ORIGINAL_PATH=`pwd`
export SANDWICH=`pwd`
export SANDWICH_METADATA=`pwd`/metadata
export LINUX_VERSION=5.18.10

export SANDWICH_OUTPUT=`pwd`/packages
export SLICE_BINARY=`pwd`/slice

# create directories

mkdir -p $SANDWICH_OUTPUT

if [ ! -d $SANDWICH/source ]
then
	mkdir -p $SANDWICH/source/tarball
	mkdir -p $SANDWICH/source/decompressed

	# download tarballs

	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$LINUX_VERSION.tar.xz -O $SANDWICH/source/tarball/linux-$LINUX_VERSION.tar.xz
fi

# download slice

if [ ! -f slice ]
then
	wget https://github.com/SandwichOS/slice/releases/download/test1/slice -O $SANDWICH/slice
	chmod +x $SANDWICH/slice
fi

# compile linux

if [ ! -d $SANDWICH/source/decompressed/linux-$LINUX_VERSION ]
then
	tar -xvf $SANDWICH/source/tarball/linux-$LINUX_VERSION.tar.xz -C $SANDWICH/source/decompressed
fi

cd $SANDWICH/source/decompressed/linux-$LINUX_VERSION

if [ ! -d slice-package ]
then
	mkdir -p slice-package/boot
fi

make defconfig && make -j8 && cp arch/x86/boot/bzImage slice-package/boot/vmlinuz-$LINUX_VERSION && cp $SANDWICH_METADATA/linux.json slice-package/metadata.json && $SLICE_BINARY create slice-package $SANDWICH_OUTPUT/linux.slicepkg

rm -r slice-package

cd $ORIGINAL_PATH