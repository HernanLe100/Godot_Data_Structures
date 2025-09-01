class_name IndexedMinHeap
extends RefCounted

var heap : Array[HeapEntry]
# "indexes" start at 1

# store unique values, inserting same value again, will change key/index
var _indexes:Dictionary[Variant, int] # map value to index of the item

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

func contains(val:Variant)->bool:
	return _indexes.has(val)

# insert a pair into heap
func insert(val:Variant, k: Variant) -> void:
	if _indexes.has(val):
		printerr("ERROR: value already exists, use change_key() instead")
		
	var entry:HeapEntry = HeapEntry.new(k, val)
	heap.append(entry) # add to end 
	_indexes[val] = heap.size()-1
	_swim(heap.size()-1) 

# move item at index up heap to maintain heap order
func _swim(index:int) -> void:
	var h :int= int(index / 2.0)
	while (index>1) && (heap[index].key < heap[h].key):
		_swap(index,h)
		index = h
		h = int(index / 2.0)
# move item at index down in heap to maintain heap order
func _sink(index:int) -> void:
	var j :int= 2*index 
	while j < heap.size(): # example: heap with 3 elements has size 4
		#var j :int= 2*index 
		if j < heap.size()-1 && heap[j].key > heap[j+1].key: # swap with the smaller of the two 
			j+=1
		if heap[index].key < heap[j].key:
			return
		_swap(index, j)
		index = j
		j = 2*index 
# swaps items between 2 indexes
func _swap(i:int, j:int) -> void:
	var aux :HeapEntry= heap[i]
	heap[i] = heap[j]
	heap[j] = aux
	var auxIndex :int= _indexes[heap[i].value]
	_indexes[heap[i].value] = _indexes[heap[j].value]
	_indexes[heap[j].value] = auxIndex

# delete the min item, return the HeapEntry
func delete_min()->HeapEntry:
	var minEntry = heap[1]
	_swap(1, heap.size()-1)
	heap.remove_at(heap.size()-1)
	_indexes.erase(minEntry.value)
	_sink(1)
	return minEntry
# delete the min item, return the key
func delete_min_key()->Variant:
	return delete_min().key
# delete the min item, return the value
func delete_min_value()->Variant:
	return delete_min().value

func get_min()->HeapEntry:
	return heap[1]
func get_min_key()->Variant:
	return heap[1].key
func get_min_value()->Variant:
	return heap[1].value


func get_heap()->Array[HeapEntry]:
	var array :Array[Variant] = []
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

# change key of item of value "from" to "toKey"
func change_key(val:Variant, toKey:Variant) -> void:
	var i:int = _indexes[val]
	heap[i].key = toKey
	_swim(i)
	_sink(i)
