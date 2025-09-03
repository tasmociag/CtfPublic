#!/usr/bin/python 

# r9 = [0..1]
# r10= [0..32]
# r11= [0..32],[0..64]

# scambled_map = [15, 0, 0, 0, 21, 0, 0, 0, 2, 0, 0, 0, 18, 0, 0, 0, 6, 0, 0, 0, 27, 0, 0, 0, 7, 0, 0, 0, 17, 0, 0, 0, 13, 0, 0, 0, 24, 0, 0, 0, 26, 0, 0, 0, 4, 0, 0, 0, 29, 0, 0, 0, 16, 0, 0, 0, 20, 0, 0, 0, 5, 0, 0, 0, 22, 0, 0, 0, 31, 0, 0, 0, 11, 0, 0, 0, 10, 0, 0, 0, 12, 0, 0, 0, 28, 0, 0, 0, 3, 0, 0, 0, 19, 0, 0, 0, 14, 0, 0, 0, 30, 0, 0, 0, 8, 0, 0, 0, 25, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 0, 9]

scramble_map = [15, 21, 2, 18, 6, 27, 7, 17, 13, 24, 26, 4, 29, 16, 20, 5, 22, 31, 11, 10, 12, 28, 3, 19, 14, 30, 8, 25,1,0,23,9]

positions = []
                
inverse_scramble = [0] * 32
for i, v in enumerate(scramble_map):
    if(v<8):
        positions.append([i,v])
    inverse_scramble[v] = i

#print(inverse_scramble)

positions = sorted(positions, key=(lambda a: a[1]))
for i in range(len(positions)):
    positions[i] = positions[i][0]

xor_string = "snakeCTF"



f = open("output.txt")
output=f.read()
output = bytes.fromhex(output)
output = list(output)

#print("output: ", output)

final_key = []

for pos in range(len(positions)):
    final_key.append(output[positions[pos]]^ord(xor_string[pos]))

final_key = ''.join(chr(x) for x in final_key)
final_key = final_key[1:]+final_key[0]
print(final_key)

flag = []

for i in range(8):
    start = i*32
    end = start+32
    block = output[start:end]
   
    shared_data = [0]*32

    for j in range(32):
        shared_data[j] = block[inverse_scramble[j]]

    for j in range(32):
        shared_data[j] ^= ord(final_key[((i + j)-(i^1)) & 0x7])
    
    for d in shared_data:
        flag.append(d)


for f in flag:
    print(chr(f),end ="")
