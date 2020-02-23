# Introduction

## Question-1
To implement parallel quick sort algorithm

Solution:<br>

- scan the input in root process from the input file
- padd the array to make size of array divisible by number of processes
- sync the processes using barrier command
- scatter chunks of data to each process and apply normal quick sort on these chunks
- merge the chunks using mergeing technique of merge sort
- now we have sorted numbers in the chunk of root process

## Question-2
To implement parallel single source shortest path algorithm

Solution:<br>

- scan the input in root process from the input file
- create graph by scanning the edges
- padd the array to make size of array divisible by number of processes
- sync the processes using barrier command
- construct dist array for each process
- scatter the graph based on number of edges
- apply belmann ford on each process
- merge all the dist arrays
- print dist array

# Run
**Compile**
```
mpic++ -std=c++11 <source-code>
```
**Running the executable**
```
mpirun -np <number-of-processes> a.out <input-file> <output-file>
```
