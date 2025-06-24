#While condition == true:
    #execute some code multiple times - until condition turns to 'false'

position = 0
end_position = 5

while position < end_position:
    position += 1
    print(position)

print("You have reached the end")

#Output:
    #1
    #2
    #3
    #4
    #5
#You have reached the end - Executed until it reaches 5 by adding 1 each time



position = 0
end_position = 10
intermediate_position = 5

while position < end_position:
    position += 1
    print(position)
    if position == intermediate_position:
        print("Game Over!")
        break
if position == end_position:
    print("You have reached the end")


#Output -
    #1
    #2
    #3
    #4
    #5
    #Game Over!
