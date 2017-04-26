#!/bin/sh

set -ex

main() {
    local svd=resources/STM32F0xx.svd
    local svd2rust=svd2rust
    $svd2rust -i $svd > src/lib.rs

    # Reformat compiler attributes removing unnecessary spaces
    # Remove spaces from # [ attribute ] => #[attribute] and add \n
    sed -i 's/\s*# \[ \([^]]*\) \]/\n#[\1]/g' src/lib.rs
    # Remove spaces from # ! [ attribute ] and add \n
    sed -i 's/\s*# ! \[ \([^]]*\) \]/#![\1]\n/g' src/lib.rs
    sed -i 's/ \([()]\) */\1/g' src/lib.rs
    # Use rustfmt to reformat to human readable format
    set +e
    rustfmt src/*.rs
    set -e

    # Test that build succeeds for target platform (ARM Cortex-M0)
    xargo build --target thumbv6m-none-eabi
}

main
