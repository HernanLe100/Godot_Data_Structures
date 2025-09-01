class_name WeightedGraph
extends RefCounted

var vertices:int
var adjacent:Array[Array]
var edges:Array[Edge]

# constructs Graph data structure, v vertices, edge connections of vertex stored in array
func _init(v:int)->void:
	vertices = v
	edges = []
	for i:int in range(v):
		adjacent.append([])

# add edge between vertices v and w, return whether edge was added or not
func add_edge(v:int, w:int, weight:float) -> bool:
	if v == w :
		return false
	if adjacent[v].has(w):
		return false
	adjacent[v].append(w)
	adjacent[w].append(v)
	var e:Edge=Edge.new(v,w,weight)
	_add_edge(e)
	return true

# binary search to add to edges, in order by weight -- usaeful for MST
func _add_edge(e:Edge):
	var index :int= edges.bsearch_custom(e, _compare_edges, false)
	edges.insert(index, e)

# return true if edge a comes before b -- smaller weight
func _compare_edges(a:Edge, b:Edge)->bool:
	return a.weight < b.weight


func has_edge(v:int, w:int) -> bool:
	return adjacent[v].has(w)

# return the vertices adjacent to v
func adj(v:int) -> Array:
	return adjacent[v]

# return number of vertices adjacent to v
func degree(v:int) -> int:
	return adjacent[v].size()
	

func min_span_tree() ->WeightedGraph:
	var mst:WeightedGraph= WeightedGraph.new(vertices)
	
	var vertexUF:UnionFind= UnionFind.new(vertices)
	for e:Edge in edges:
		if !vertexUF.connected(e.v,e.w):
			vertexUF.union(e.v,e.w)
			mst.add_edge(e.v, e.w, e.weight)
			if mst.edges.size() == vertices-1: # MST has V-1 edges
				return mst
				
	return mst

# creates new copy of this weighted graph
func duplicate()->WeightedGraph:
	var wg:WeightedGraph=WeightedGraph.new(vertices)
	wg.adjacent = adjacent.duplicate()
	wg.edges = edges.duplicate()
	return wg

	
