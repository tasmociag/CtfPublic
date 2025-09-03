#!/usr/bin/python3

def rotl(value, shift):
    value1 = value << shift
    value2= value >> (8-shift)

    return value1|value2


baked = "62e4d573e6ac9cbd7260d1a14766d73a68667d2303aed9347d"
baked = bytes.fromhex(baked)
print(baked)

sol=b''
counter=0
for h in baked:
    for i in range(127):
        rotated=rotl(i,counter&0x7)
        al = rotated&0xff
        dl = h&0xff
        if al==dl:
            sol+=i.to_bytes()
    counter+=1

print(sol)
