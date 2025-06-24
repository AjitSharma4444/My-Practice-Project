actions = {"r":1, "l":-1} # Key - Strings , Value - Num : although there are multiple combination possibilities
print(actions)

#Output : {'r': 1, 'l': -1}


print(actions["r"]) # Output - value of "r" Retrive the key

print(actions.get("g")) # Give result if strings exists - output: None


actions["u"] = 1

print(actions) # Output - {'r': 1, 'l': -1, 'u': 1}

actions["r"] = 2

print(actions) #Output - {'r': 2, 'l': -1, 'u': 1}

print(actions.keys())
print(actions.values())
print(actions.items())

# Output: dict_keys(['r', 'l', 'u'])
#dict_values([2, -1, 1])
#dict_items([('r', 2), ('l', -1), ('u', 1)])

#Deleting Element
del(actions["u"])
print(actions) # Output - {'r': 2, 'l': -1}

actions.pop("r")
print(actions) # Output - {'l': -1}

print("l" in actions)  # Output True
