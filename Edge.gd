class_name Edge
extends RefCounted

# used for MST

var v: int
var w: int
var weight: float

func _init(start:int, end:int, m: float)->void:
	v = start
	w = end
	weight = m
	
func _to_string() -> String:
	return str(v,"-",w, ": ", weight)
