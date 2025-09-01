class_name MaxHeap
extends RefCounted

var heap : Array[HeapEntry]
# "indexes" start at 1

# use class to allow values to be sorted by a key
class HeapEntry extends RefCounted:
	var key: Variant
	var value : Variant
	
	func _init(k:Variant, v:Variant)->void:
		key = k
		value = v
	func _to_string() -> String:
		return str("(key: ", key, ", val: ", value, ")")

# construct empty heap
func _init() -> void:
	heap = [null]
# number of elements in heap
func get_size()->int:
	return heap.size()-1

# insert item into heap
func insert(x : Variant) -> void:
	heap.append(HeapEntry.new(x, 0)) # add to end 
	_swim(heap.size()-1) 
# insert a pair into heap
func insert_pair(k: Variant, v:Variant) -> void:
	heap.append(HeapEntry.new(k, v)) # add to end 
	_swim(heap.size()-1) 

# move item at index up heap to maintain heap order
func _swim(index:int) -> void:
	var h :int= int(index / 2.0)
	while (index>1) && (heap[index].key > heap[h].key):
		_swap(index,h)
		index = h
		h = int(index / 2.0)
# move item at index down in heap to maintain heap order
func _sink(index:int) -> void:
	var j :int= 2*index 
	while j < heap.size(): # example: heap with 3 elements has size 4
		#var j :int= 2*index 
		if j < heap.size()-1 && heap[j].key < heap[j+1].key: # swap with the larger of the two 
			j+=1
		if heap[index].key > heap[j].key:
			return
		_swap(index, j)
		index = j
		j = 2*index 
# swaps items between 2 indexes
func _swap(i:int, j:int) -> void:
	var aux :Variant= heap[i]
	heap[i] = heap[j]
	heap[j] = aux

# delete the max item, return the HeapEntry
func delete_max()->HeapEntry:
	var maxEntry = heap[1]
	_swap(1, heap.size()-1)
	heap.remove_at(heap.size()-1)
	_sink(1)
	return maxEntry
# delete the max item, return the key
func delete_max_key()->Variant:
	return delete_max().key
# delete the max item, return the value
func delete_max_value()->Variant:
	return delete_max().value

func get_max()->HeapEntry:
	return heap[1]
func get_max_key()->Variant:
	return heap[1].key
func get_max_value()->Variant:
	return heap[1].value


func get_heap()->Array[HeapEntry]:
	var array :Array[HeapEntry] = []
	var i:int=1
	while i<heap.size():
		array.append(heap[i])
		i+=1
	return array
func get_keys()-> Array[Variant]:
	var array :Array[Variant] = []
	var i:int=1
	while i<heap.size():
		array.append(heap[i].key)
		i+=1
	return array
func get_values()-> Array[Variant]:
	var array :Array[Variant] = []
	var i:int=1
	while i<heap.size():
		array.append(heap[i].value)
		i+=1
	return array
