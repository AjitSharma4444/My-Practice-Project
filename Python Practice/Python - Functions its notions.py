# def function_name():
        #function body
#Try to restrict your function to one purpose only

position = 0

def move_player():
    global position  # call upon variable outside the declared outside the function
    position += 1
    print(position)

move_player()
    
