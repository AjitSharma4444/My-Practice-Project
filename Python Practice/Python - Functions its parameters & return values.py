# parameters - take value as inputs for temporary variable
# parameters is a enhanced functions by allowing us to choose how much we want to increase our position by


position = 0
#1
def move_player(by_amount):
    global position
    position += by_amount
    print(position)

move_player(5) # by how much position we want to move the player

#2
def move_player(position, by_amount):
    position += by_amount
    print(position)

move_player(position, 5) 

