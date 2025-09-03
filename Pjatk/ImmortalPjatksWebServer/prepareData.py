def reverse_hex_pairs(hex_str):
    byte_pairs = [hex_str[i:i+2] for i in range(0, len(hex_str), 2)]
    reversed_pairs = byte_pairs[::-1]
    return ''.join(reversed_pairs)

def xor_hex_array(hex_array, key):
    result = []
    for hex_str in hex_array:
        value = int(hex_str, 16)
        xored = value ^ key
        result.append(f'{xored:08x}')
    return result


data = ["Host:","User-Agent:","Accept:","Niesmiertelna-nawijka-pjatk-skladowa:"]
hex_data=[]
for s in data:
    hex_list = [hex(ord(c)) for c in s]
    blob=0
    hex_blob=""
    hex_data.append([])
    for hex_value in hex_list:
        print(hex_value[2:],end = "")
        hex_blob+=hex_value[2:]
        blob+=1
        if blob==4:
            print(" ", end="")
            hex_data[len(hex_data)-1].append(hex_blob)
            hex_blob=""
            blob=0
    for i in range(4-blob):
        print("00", end="")
        hex_blob+="00";
    hex_data[len(hex_data)-1].append(hex_blob)
    print(" - ", len(hex_list))


print(hex_data)
key = 0x12345678

for i in range(len(hex_data)):
    for j in range(len(hex_data[i])):
        hex_data[i][j] = reverse_hex_pairs(hex_data[i][j])

print(hex_data)

for i in range(len(hex_data)):
    hex_data[i] = xor_hex_array(hex_data[i],key)

print(hex_data)

for data in hex_data:
    for string in data:
        print(string, end = " ")
    print()

# print(xor_hex_array(hex_data[0],key))
# print(xor_hex_array(xor_hex_array(hex_data[0],key),key))
