print("""
              🎂🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🎂
              🍰                            🍰
              🍰  Baker Brian's Cake Vault  🍰
              🍰                            🍰
              🎂🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🍰🎂
""")

# Make sure nobody else tries to enter my vault
username = input("Enter Username:\n> ")
if username != "Br14n_th3_b3st_c4k3_b4k3r":
    print("❌ Go away, only Baker Brian has access!")
    exit()

# Password check if anybody guesses my username
# Naturally complies with all modern standards, nothing weak like "Tr0ub4dor&3"
password = input("\nEnter password:\n> ")

# Check each word separately
words = password.split("-")

# Word 1
if not (
    len(words) > 0 and
    words[0] == "red"
):
    print("❌ Word 1: Wrong - get out!")
    exit()
else:
    print("✅ Word 1: Correct!")

# Word 2
if not (
    len(words) > 1 and
    words[1][::-1] == "yromem"
):
    print("❌ Word 2: Wrong - get out!")
    exit()
else:
    print("✅ Word 2: Correct!")

# Word 3
if not (
    len(words) > 2 and
    len(words[2]) == 5 and
    words[2][0] == "b" and
    words[2][1] == "e" and
    words[2][2:4] == "r" * 2 and
    words[2][-1] == words[1][-1]
):
    print("❌ Word 3: Wrong - get out!")
    exit()
else:
    print("✅ Word 3: Correct!")

# Word 4
if not (
    len(words) > 3 and
    words[3] == words[0][:2] + words[1][:3] + words[2][:3]
):
    print("❌ Word 4: Wrong - get out!")
    exit()
else:
    print("✅ Word 4: Correct!")

# Password length
if len(password) != len(username):
    print("❌ Wrong password length, get out!")
    exit()

# Nobody will crack that password, access can be granted
print("\nWelcome back, Brian! Your vault has been opened:\n")
with open("cake_vault.txt") as f:
    print(f.read())
