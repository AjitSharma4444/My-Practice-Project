high_score = ("Nimish", 120)
print(high_score)
print(
"hello"



      )
high_score = ("Holly", 150)
print(high_score) # Take data from latest update -> 'Holly', 150

# high_score[0] = "james" # TypeError: 'tuple' object does not support item assignment

name = high_score[0]
print(name)

# Modification Operations not applicable in Tuple like List- insert, append, remove, delete etc.
#however fetch items from strings , check if something is exist , and length of string
print(len(high_score)) # Give count of elements

#True or False - get it by below code:

print("Nimish" in high_score) # False

print("Holly" in high_score) # True

print(name[0])
print(name[0:2])
print("Hol" in name)
print(len(name))

#Output:
#H
#Ho
#True
#5

# We can't reassign individual elements , we can access tuple contains a value


