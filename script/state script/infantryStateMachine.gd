extends Node


@export var startingState : State 

var currentState : State 
var states : Array = []


func init(parent: Node3D) -> void :
	for child in get_children():
		child.parent = parent
		states.append(str(child.name))
	
	changeState(startingState)
	print(states)

func changeState(newState : State) -> void :
	if currentState :
		currentState.exit()
	
	currentState = newState
	currentState.enter()


func _process_input(event : InputEvent) -> void :
	var newState = currentState._process_input(event)
	if newState :
		changeState(newState)


func _process_frame(delta: float) -> void :
	var newState = currentState._process_frame(delta)
	if newState :
		changeState(newState)


func _process_physics(delta: float) -> void:
	var newState = currentState._process_physics(delta)
	if newState :
		changeState(newState)


func move() -> void :
	changeState(get_child( states.find("moving State")))
