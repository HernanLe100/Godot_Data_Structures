class_name MinSpanTree
extends RefCounted

# creates MST from input array of points
var graph :WeightedGraph
var vertices: Array[Vector2]

# weights from distances are kept squared to be more efficient

func _init( inputPoints:Array[Vector2])->void:
	vertices = inputPoints
	var g = WeightedGraph.new(inputPoints.size())
	for v:int in range(inputPoints.size()):
		for w:int in range(v+1, inputPoints.size()):
			g.add_edge(v,w,inputPoints[v].distance_squared_to(inputPoints[w]))
	graph = g.min_span_tree()
	
func get_graph() -> WeightedGraph:
	return graph
func get_edges() -> Array[Edge]:
	return graph.edges
