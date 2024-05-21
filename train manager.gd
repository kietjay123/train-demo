extends Node

const trainCar = preload("res://script/train_car.gd") 

@onready var railSystem = $'/root/root/rail system/Path3D'
@onready var gridSize = $"/root/root/GridMap".cell_size.x

var head : trainCar
var tail : trainCar



func _init():
	head = null
	tail = null

func isEmpty() -> bool :
	return(head == null)


func clear() -> void :
	head = null
	tail = null
	for i in $'train'.get_child_count() :
		get_child(i - 1).queue_free()


func add(x : Node3D) -> trainCar :
	if (isEmpty()) :
		var newTrainCar := trainCar.new(x, null, null)
		head = newTrainCar
		tail = newTrainCar
		return newTrainCar
		
	else :
		var newTrainCar := trainCar.new(x, tail, null)
		tail.next = newTrainCar
		tail = newTrainCar
		return newTrainCar



##unit testing needed
func addAt(x : Node3D , index : int) -> trainCar :
	if index > size() :
		print("invalid index")
		return 
	elif index == size(): #add tail
		return add(x)
	else :
		var current : trainCar = goto(index)
		var pre : trainCar = current.pre
		if current == head : 
			var newTrainCar := trainCar.new(x, null, current)
			head = newTrainCar
			current.pre = head
			return newTrainCar
		else : 
			var newTrainCar : trainCar = trainCar.new(x, pre, current)
			pre.next = newTrainCar
			current.pre = newTrainCar
			return newTrainCar


func delete() -> void :
	if size() <= 1 :
		clear()
	else :
		tail = tail.pre
		tail.next = null


func deleteAt(index : int) -> void :
	if index >= size() :
		print("invalid index")
		return
	else :
		if size() <= 1 :
			clear()
			return
		var current : trainCar = goto(index)
		var pre : trainCar = current.pre
		var next : trainCar = current.next
		if pre == null : # remove head
			head = head.next
			head.pre = null
		elif next == null : # remove tail
			tail = tail.pre
			tail.next = null
		else :
			pre.next = next
			next.pre = pre


func goto(x : int) -> trainCar:
	var current : trainCar = head
	var count : int = 0
	while (current != null) :
		if (count == x) :
			return current
		count += 1
		current = current.next
	print("non exist car")
	return


func size() -> int :
	var current : trainCar = head
	var result : int  = 0
	while current != null :
		current = current.next
		result += 1
	return result


func _ready():
	pass

##DEBUG PURPOSE###
#func _input(event) -> void:
#	if event is InputEventKey :
#		if event.pressed && event.keycode == KEY_1 : #size
#			print(size())
#			print(self)
#		elif event.pressed && event.keycode == KEY_2 : #add at
#			addAt(5,0)
#			print(self)
#		elif event.pressed && event.keycode == KEY_3 : #delete
#			delete()
#			print(self)
#		elif event.pressed && event.keycode == KEY_4 : #delete at
#			deleteAt(0)
#			print(self)


#func _to_string() -> String:
#	var result : String
#	var carID : String = ""
#	var current : trainCar = head
#	while current != null :
#		if current.pre == null && current.next == null :
#			carID += "(" + str(current.info) + ", null, null)"
#		elif current.pre == null :
#			carID += "(" + str(current.info) + ", " + "null" + ", " + str(current.next.info) + ")"
#		elif current.next == null :
#			carID += "(" + str(current.info) + ", " + str(current.pre.info) + ", " + "null" + ")"
#		else :
#			carID += "(" + str(current.info) + ", " + str(current.pre.info) + ", " + str(current.next.info) + ")"
#		current = current.next
#	result = "[" + carID + "]"
#	return result



