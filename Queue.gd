class_name Queue
extends RefCounted

# use queue for level order traversal, linked list so no need to resize
var front : QueueNode
var back: QueueNode
var size : int

class QueueNode extends RefCounted:
	var value: Variant
	var next : QueueNode
	func _init(val : Variant)->void:
		value = val
		next = null
	
# construct empty queue
func _init():
	front = null
	back = null
	size = 0
# add to the end of the queue
func enqueue(val:Variant)->void:
	if size == 0:
		front = QueueNode.new(val)
		back = front
	else:
		back.next = QueueNode.new(val)
		back = back.next
	size+=1
# remove from the fron tof the queue and return value
func dequeue() -> Variant:
	var fNode :QueueNode= front
	front = front.next
	size-=1
	return fNode.value
# returns boolean whether queue is empty or not
func is_empty()->bool:
	return size == 0
# return value at front without removing front
func peek() -> Variant:
	if size == 0:
		return null
	return front.value
