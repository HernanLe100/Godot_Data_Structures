class_name KDTree
extends RefCounted

# 2d tree
var root: KDTreeNode 
var size:int

# nested class representing the nodes of the tree
class KDTreeNode extends RefCounted:
	var point: Vector2 # tree ordered by points
	var value: Variant # value mapped to the point
	var rect: Rect2 # represents area covered by the point
	
	var left : KDTreeNode
	var right: KDTreeNode
	
	func _init(p:Vector2, v:Variant, r:Rect2) -> void:
		point = p
		value = v
		rect = r

# construct empty KDTree
func _init() ->void:
	root = null
	size = 0

# helper method to compare and order points
func _compare(p1: Vector2, p2: Vector2, vert:bool) -> float:
	if vert: # if dividing line is vertical
		return p1.x - p2.x
	else:
		return p1.y - p2.y

# helper method to resize the rectangle of each node
func _resize_rect(rect:Rect2, vert:bool, comp:float, p:Vector2) ->Rect2:
	if vert:
		if comp<0: # to the left
			return Rect2(rect.position.x , rect.position.y, p.x-rect.position.x, rect.size.y)
		else: # to the right 
			return Rect2(p.x , rect.position.y, rect.end.x-p.x, rect.size.y)
	else:
		if comp<0: # above
			return Rect2(rect.position.x , rect.position.y, rect.size.x, p.y-rect.position.y)
		else: # below
			return Rect2(rect.position.x , p.y , rect.size.x, rect.end.y - p.y)

# assume points will not be outside of this range
const MIN_VALUE :int= -1000000
const MAX_VALUE :int= 1000000
# puts val into tree with point p as key
func put(p:Vector2, val:Variant)->void:
	root = _put(root, p, val, true, Rect2(MIN_VALUE, MIN_VALUE, 2*MAX_VALUE, 2*MAX_VALUE ))
	size+=1
	# vert represents whether dividing line is vertical

# recursive function for main put() method
func _put(current:KDTreeNode, p:Vector2, val:Variant, vert:bool, rect:Rect2) ->KDTreeNode:
	if current == null:
		return KDTreeNode.new(p, val, rect)
	if p == current.point: # override if same point
		current.value = val
		size-=1 # decrement size because size will be incremented again
		return current
	var comp:float= _compare(p, current.point, vert)
	rect = _resize_rect(rect, vert, comp, current.point)
	if comp<0:
		current.left = _put(current.left, p, val, !vert, rect)
	else:
		current.right = _put(current.right, p, val, !vert, rect)
	return current

# return value at given point
func get_value(p:Vector2) -> Variant:
	return _get_value(root, p, true)
# recursive function for main get_value() method
func _get_value(current:KDTreeNode, p:Vector2, vert:bool) ->Variant:
	if current == null:
		return null
	if p == current.point:
		return current.value
	var comp :float= _compare(p, current.point, vert)
	if comp<0:
		return _get_value(current.left, p, !vert)
	else:
		return _get_value(current.right, p, !vert)

# does tree contain point p
func contains(p : Vector2) ->bool:
	return get_value(p) != null

# return points in tree in level order
func all_points() -> Array[Vector2]:
	if root == null:
		return []
	var aux :Queue= Queue.new()
	var pointsArray :Array[Vector2]= []
	
	aux.enqueue(root)
	while !aux.is_empty():
		var current :KDTreeNode= aux.dequeue()
		if current.left != null:
			aux.enqueue(current.left)
		if current.right != null:
			aux.enqueue(current.right)
		pointsArray.append(current.point)
	return pointsArray

# points in given rectangle
func points_in_range(rect: Rect2) -> Array[Vector2]:
	var pointsArray:Array[Vector2] = []
	_points_in_range(root, rect, pointsArray) # pass reference
	return pointsArray
# recursive function for main points_in_range() method
func _points_in_range(current:KDTreeNode, rect:Rect2, pointsArray) -> void:
	if current == null:
		return
	# if rectangle contains point or on right/bottom edges
	if rect.has_point(current.point)\
	 || (current.point.x==rect.end.x && current.point.y>=rect.position.y && current.point.y<=rect.end.y)\
	 || (current.point.y==rect.end.y && current.point.x>=rect.position.x && current.point.x<=rect.end.x):
		pointsArray.append(current.point)
	
	
	if current.left != null && current.left.rect.intersects(rect, true): # true - include borders
		_points_in_range(current.left, rect, pointsArray)
	if current.right != null && current.right.rect.intersects(rect, true): # true - include borders
		_points_in_range(current.right, rect, pointsArray)

# point closest to given point p
func nearest(p:Vector2) -> Vector2:
	if root == null:
		return Vector2(MIN_VALUE, MIN_VALUE)
	return _nearest(root, p, true, null, (4*MAX_VALUE)**2).point

# recursive function for main nearest() method, returns Node of nearest point to more easily work recursively
func _nearest(current:KDTreeNode, p:Vector2, vert:bool, best:KDTreeNode, bestDistSq:float) -> KDTreeNode:
	if current == null:
		return null
	if p == current.point:
		return current
	var bestN : KDTreeNode = best
	var bestDS :float= bestDistSq
	
	var distSq = p.distance_squared_to(current.point)
	if distSq < bestDistSq:
		bestDS = distSq
		bestN = current
	
	# recursion: discard if not shorter and explore towards point p
	var comp :float= _compare(p, current.point, vert)
	if comp<0: # to left
		if current.left != null:
			bestN = _nearest(current.left, p, !vert, bestN, bestDS)
		bestDS =  p.distance_squared_to(bestN.point)
		# search right as well
		if current.right != null && _distance_squared_to_rect(p, current.right.rect) < bestDS:
			bestN = _nearest(current.right, p, !vert, bestN, bestDS)
	else: # to right
		if current.right != null:
			bestN = _nearest(current.right, p, !vert, bestN, bestDS)
		bestDS =  p.distance_squared_to(bestN.point)
		# search left as well
		if current.left != null && _distance_squared_to_rect(p, current.left.rect) < bestDS:
			bestN = _nearest(current.left, p, !vert, bestN, bestDS)
	return bestN # finally return best node after searches
	

# helper method finds the distance from point to edge of rect
func _distance_squared_to_rect(p:Vector2, rect: Rect2) ->float:
	var dx :float = 0
	var dy :float = 0
	var right :float= rect.end.x
	var left: float= rect.position.x
	var top: float = rect.position.y
	var bottom: float = rect.end.y
	
	if p.x > right :
		dx = p.x-right
	elif p.x < left:
		dx = left - p.x
	if p.y > bottom :
		dy = p.y-bottom
	elif p.y < top:
		dy = top - p.y
	
	return dx**2 + dy**2


# closest k points to p
func nearest_neighbors(p:Vector2, k:int) -> Array[Vector2]:
	if root == null:
		return Array([], TYPE_VECTOR2, "", null)
	# store distance squared as key, point as value
	var pointsHeap :MaxHeap= MaxHeap.new()
	_nearest_neighbors(root, p, true, pointsHeap)
	
	while pointsHeap.get_size() > k:
		pointsHeap.delete_max() # get the closest k 
	
	return Array(pointsHeap.get_values(), TYPE_VECTOR2, "", null)

# recursive function for main nearest_neighbors() method
func _nearest_neighbors(current:KDTreeNode, p:Vector2, vert:bool, pointsHeap:MaxHeap) -> void:
	if current == null:
		return
	
	pointsHeap.insert_pair(p.distance_squared_to(current.point), current.point)
	
	# recursion: prune branch if not shorter than max distance, explore towards point p
	var comp :float= _compare(p, current.point, vert)
	if comp<0: # to left
		if current.left != null:
			_nearest_neighbors(current.left, p, !vert, pointsHeap)
		
		# search right as well if could contain a shorter distance
		if current.right != null && _distance_squared_to_rect(p, current.right.rect) < pointsHeap.get_max_key():
			_nearest_neighbors(current.right, p, !vert, pointsHeap)
	else: # to right
		if current.right != null:
			_nearest_neighbors(current.right, p, !vert, pointsHeap)
		
		# search left as well
		if current.left != null && _distance_squared_to_rect(p, current.left.rect) < pointsHeap.get_max_key() :
			_nearest_neighbors(current.left, p, !vert, pointsHeap)
	
	
	
	
