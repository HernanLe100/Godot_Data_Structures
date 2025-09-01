# Godot_Data_Structures
A collection of data structure scripts that make up kNN search and graph algorithms in GDScript
- written in Godot 4.4

Fun fact: this code is adapted from personal programs written in Java!

# Data Structures
## KD Tree
KDTree.gd
- a 2D binary tree that is used to store a **value** based on a Vector2 **point**
- uses recursive helper methods to insert and search
  - has nearest neighbor and k nearest neighbors search
- uses Queue.gd and MaxHeap.gd

## Weighted Graph
WeightedGraph.gd
- implements a graph data structure with weighted edges
- has a minimum spanning tree function that returns the MST based on the current edges in the graph
- uses Edge.gd, UnionFind.gd

## Minimum Spanning Tree
MinSpanTree.gd
- given an array of Vector2 points, this script will return a spanning tree (as a WeightedGraph) with the shortest edge sum
- used WeightedGraph.gd

## Edge
Edge.gd
- simply stores information about the vertices and the weight of an edge
- not intended for use on its own

## Queue
Queue.gd
- Because Godot's Array data type is dynamic, removing from the front shifts the remaining elements to the left, resulting in an O(n) time complexity.
- implements a queue data structure as a linked list to circumvent the O(n) dequeue time

## Union-Find
UnionFind.gd
- manages sets of elements
- can be used to tell if elements are in the same group

## Max Heap
MaxHeap.gd
- binary heap data structure with the largest **key** on top

## Indexed Min Heap (Min Priority Queue)
IndexedMinHeap.gd
- binary heap data structure with the smallest **key** (index) on top
- has a function to change keys, which will update the heap order if needed

# Algorithms that can be implemented
## Kruskal
- implemented in WeightedGraph.gd **min_span_tree()**
- uses a weighted graph and union-find

## Dijkstra
- can be implemented using a weighted graph and an indexed min heap

## kNN search
- implemented in KDTree.gd **nearest_neighbors()** and _nearest_neighbors()
- uses a max heap



