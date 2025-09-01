class_name UnionFind
extends RefCounted


var parent:Array[int] # parent[i] is parent of i
var size:Array[int] # size[i] is number of elements with root i
var groups : int # number of separated groups

# constructor to set up UF with n items
func _init(n : int)->void:
	for i:int in range(n):
		parent.append(i)
		size.append(1)
	groups = n

# get the leader of p
func find(p:int)->int:
	while p!=parent[p]:
		p = parent[p]
	return p

func connected(p:int, q:int)->bool:
	return find(p) == find(q)

func union(p:int, q:int) -> void:
	var rootP :int= find(p)
	var rootQ :int= find(q)
	if rootP == rootQ:
		return
	# smaller points to larger, q to p if same
	if size[rootP] < size[rootQ]:
		parent[rootP] = rootQ
		size[rootQ] += size[rootP]
	else:
		parent[rootQ] = rootP
		size[rootP] += size[rootQ]
	groups-=1
