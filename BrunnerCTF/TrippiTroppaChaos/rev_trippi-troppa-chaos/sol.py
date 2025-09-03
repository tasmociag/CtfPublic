#!/usr/bin/python3
from itertools import cycle
from hashlib import sha256
from base64 import b85encode
from base64 import b85decode

x = b'skibidi'
y = b'skibidi'

f = open("output.txt")

payload = f.read()
#print(payload)

# reutrn array of 0 ex. [0,0,0,0,0,0]

    
l1 = lambda x, y: ( lambda z: [c for c in z])   (
    [___x___ ^ ___y___ for ___x___, ___y___ in zip(x, cycle(y))]
)



def f1(arg_x, arg_y):
    return (lambda x: x.digest()[:len(arg_y)])(
        sha256(
            ((arg_x.decode() if isinstance(arg_x, bytes) else arg_x) +
            (arg_y.decode() if isinstance(arg_y, bytes) else arg_y)).encode()
        )
    )


# cos tam ten 
def f2(arg_x):
    return (lambda x:[c for c in x])([((sahur * 7) % 256) for sahur in arg_x])

def f2_rev(arg_x): 
    ret = b''
    for b in arg_x:
        #print(b, end=" : ")
        temp = b
        while(temp%7!=0):
            temp+=256
        #print(int(temp/7).to_bytes(1))
        ret+=int(temp/7).to_bytes(1)
    return ret

#odwraca
def f3(x):
    return (lambda arg_x: arg_x[::-1])(x)

#print(f1(x,y))

step_one = b'\xf8\xded\xedn\xe6('
content_of_the_flag=""

step_2 = l1(content_of_the_flag, step_one)

step_3 = bytes(f2(b'\x01\x01\x03\x04'))

step_4 = f3(step_3)

step_5 = b85encode(step_4).decode()

step_4 = b85decode(payload.encode())
#print("step_4: ", step_4)
step_3 = f3(step_4)
#print("step_3: ", step_3)
step_2 = f2_rev(step_3)
#print("step_2: ", step_2)

step_1 = bytes(l1(step_2,step_one))

#print(step_3)
#print(step_4)
print(len(step_1))
print(step_1)
#w = open("result.txt","w+")
#w.write(step_1)
