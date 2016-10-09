#!/usr/bin/python
# 0xbeb97 - Dump object file into a C string

import re
import sys
import subprocess


if len(sys.argv) != 2:
    print('Usage: {} binary'.format(sys.argv[0]))
    sys.exit(-1)

output = subprocess.check_output(['objcopy', sys.argv[1], '/dev/null', '--dump-section', '.text=/dev/stdout'])

hexvals = ['\\x{:02x}'.format(ord(b)) for b in output]

hexstr = ''.join(hexvals)
print('char payload[{}] = "{}";'.format(len(hexvals), hexstr))

