# Introduction 
Using RMI, implement MST query service. The server would manage a list of graphs. Clients can add graphs, modify graphs or query for MST of the graph.
 
# Run
**Compile**
```
javac *.java
```
**Start Server**
```
java Server <port>
```
**Start Client**
```
java Client <server-ip> <server-port>  
```

# File Architecture
- MstImpl.java
- Mst.java
- Client.java
- Server.java
- README.md

# Algorithm Implementation
Prim's algorithm for finding MST is used. If the graph contains MST, it will return size of MST, else it will return -1 when MST does not exist. 


## Command Usage:

1. `add_edge`:Adds an edge between 2 nodes.     
   ```
   add_edge graph_name node1 node2 weight
   ```
   
2. `add_graph`:Adds a graph.     
   ```
   add_graph graph_name no_of_nodes
   ```
   
3. `get_mst`:Query for mst of a graph.     
   ```
   get_mstt graph_name
   ```
   
**Note:-** Input is assumed to be consistent so error handling for inconsistent input not implemented.

