#!/bin/sh

set -ex

main() {
    local svd=resources/STM32F0xx.svd

    svd2rust -i $svd > src/lib.rs

    # Reformat pragmas removing unnecessary spaces
    sed -i 's/\s*# \[ \([^]]*\) \]/\n#[\1]/g' src/lib.rs
    sed -i 's/\s*# ! \[ \([^]]*\) \]/#![\1]\n/g' src/lib.rs

    # Use rustfmt to reformat to human readable format
    set +e
    rustfmt src/*.rs
    set -e

    # Test that build succeeds for target platform (ARM Cortex-M0)
    xargo build --target thumbv6m-none-eabi
}

main
