# About
This is an implementation of Edmonds–Karp algorithm (Breadth first search specialization of Ford-Fulkerson Algorithm) for Maximum Flow Problem in Ruby

# Use
Method maximum_flow() should be called with 3 cumpulsory parameters:


1. sources: array with source names

        e.g. ['city1', 'city2', 'city3']
2. sinks: array with sink names

        e.g. ['city4', 'city5']
3. graph_edges: 
array with strings containing two vertices and flow seperated with #(default)

        e.g. ['city1#city2#5', 'city2,city4,20']


2 optional parameters are also provide:

1. directed:  takes boolean value (default: true) 

              true: treats all graph edges as directed
              false: treats all graph edges as undirected
2. splitter: For graph_edges, default splitter between vertices and flow value is '#'. It can be set using spliiter parameter.

        e.g. splitter: ','
