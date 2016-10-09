#!/bin/bash
# 0xbeb97 - generate a comparison of AT&T and Intel assembly outputs
# set -x

if [ "$#" -ne 1 ]; then
    echo usage: $0 objfile
    exit
fi

if [ ! -f $1 ]; then
    echo object file $1 does not exist! Exiting...
    exit
fi

function dump_disasm() {
    # zeroth para: retun value var
    # first param: intel / att
    # 2nd param: input file
    # 3rd param: output file
    # return via echoing the filename
    local temp=$(mktemp)
    objdump -d -M "$2" "$3" | tail -n+7 > "$temp"

    eval "$1='$temp'"
}

intel_asm=''
dump_disasm intel_asm intel $1
att_asm=''
dump_disasm att_asm att $1

# Get rid of the address and opcode list for intel
intel_asm_only=$(mktemp)
cut -f3- $intel_asm > $intel_asm_only

paste $att_asm $intel_asm_only | expand -t 10,35,70

# Cleanup the temp files
rm $intel_asm
rm $intel_asm_only
rm $att_asm
