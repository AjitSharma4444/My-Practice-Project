#if condition = True:
    #execute some code
key = "u"

if key == "r":
    print("move right") # Print 'move right' , as key = "r"

print("done") # This is indipendent

#ElseIF - elif

if key == "r":
    print("move right") # if key == "r"
elif key == "l":
    print("move left") # if key == "l"
else:
    print("invalid key") # if key == "u"
