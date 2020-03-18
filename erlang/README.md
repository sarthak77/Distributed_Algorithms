# Introduction

## Question-1
Write a program to pass integer token value around all processes in a ring-loke fashion, ensuring no deadlock

Solution:<br>

- scan the arguments
- read input from the input file
- create N processes and pass the token using a for loop

## Question-2
To implement parallel merge sort algorithm

Solution:<br>

- scan the arguments
- read input from the input file
- convert numbers from string to integer
- split the list into NOP parts
- create a base process which will merge all lists
- create other processes using a for loop

# Run
**Compile**
```
erlc <program_file>
```
**Running the executable**
```
erl -noshell -s <module_name> main <input_file> <output_file> -s init stop
```
