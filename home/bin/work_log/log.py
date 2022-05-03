#!/usr/bin/python3

import sys
from datetime import datetime

tag = sys.argv[1]

with open('/home/mweber/logins.txt', 'a+') as f:
    f.write(tag + "\t" + datetime.now().strftime("%d.%m.%Y %H:%M:%S") + "\n")
