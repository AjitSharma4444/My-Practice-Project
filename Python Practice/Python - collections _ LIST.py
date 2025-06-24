name = [5, True, "String"] # List can be empty as well
column_positions = [5, 10, 50]
column_positions = [5, 10, 50, 20]
print(column_positions)
[5, 10, 50, 20]

print(column_positions[0])
5
>>> # to access List, need to write the position
>>> print(column_positions[3])
20
>>> column_positions[0] = 6
>>> print(column_positions)
[6, 10, 50, 20]
>>> # changed data from the specific position
>>> 
>>> print(column_positions)
[6, 10, 50, 20]
>>> print[0:2] # to print first two elements, need to mention +1 position after :
Traceback (most recent call last):
  File "<pyshell#13>", line 1, in <module>
    print[0:2] # to print first two elements, need to mention +1 position after :
TypeError: 'builtin_function_or_method' object is not subscriptable
>>> print(column_positions[0:2])
[6, 10]
>>> 
>>> # Append or update to the data list
>>> column_positions.append(25)
>>> print(column_positions)
[6, 10, 50, 20, 25]
>>> # insert in specific position, need to give the position number
>>> column_positions.insert(1, 9)
>>> print(column_positions)
[6, 9, 10, 50, 20, 25]
>>> 
>>> # Remove with position specific
>>> column_positions.remove(6)
>>> print(column_positions)
[9, 10, 50, 20, 25]
>>> # Remove specific data from list
>>> 
>>> del(column_positions[2])
>>> print(column_positions)
[9, 10, 20, 25]
>>> # it deletes the data on position 2
