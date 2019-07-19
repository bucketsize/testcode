#!/bin/bash

DIR='4.18-rc8'
VER='4.18'
PATCH='0-041800rc8-generic_4.18.0-041800rc8.201808052031'
GEN=`echo $PATCH | sed 's/-generic//'`
ARCH='amd64'

mkdir /var/tmp/$DIR
cd /var/tmp/$DIR

getk(){
    dir=$1
    fna=$2
    if [ -f $fna ]; then
        echo 'skip ' $fna
    else
        echo 'get ' $dir $fna
        wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v$dir/$fna
    fi
}

getk $DIR linux-headers-$VER.${GEN}_all.deb
getk $DIR linux-headers-$VER.${PATCH}_$ARCH.deb
getk $DIR linux-modules-$VER.${PATCH}_$ARCH.deb
getk $DIR linux-image-unsigned-$VER.${PATCH}_$ARCH.deb

echo "sudo dpkg -i *.deb"
