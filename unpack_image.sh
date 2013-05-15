#!/bin/bash

strip() {
    cp $@ out.img
    unpackbootimg -i out.img > image_info.txt
    BIT=`grep "Android magic found at:" image_info.txt | cut -d ':' -f 2 | cut -c 2-`

    if [ $BIT -gt 0 ]; then
        dd bs=$BIT skip=1 if=out.img of=unsigned.img
    fi
}

extract() {
    mkdir ramdisk
    cd ramdisk
    gunzip -c ../out.img-ramdisk.gz | cpio -i
    cd ..
}

delout() {
    rm out.img out.img-base out.img-cmdline out.img-pagesize
}

if [ -f $@ ]; then
    strip $@
    extract
    delout
else
    echo "No image specified"
fi

