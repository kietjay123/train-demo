class_name Infantry
extends Node3D

@onready var stateMachine = $"infantry State Machine"
@export var stats : Unit 

var path : PackedVector2Array = []

func _ready() -> void : 
	
	stateMachine.init(self)
	if stats :
		pass
	

func _unhandled_input(event) -> void :
	stateMachine._process_input(event)


func _physics_process(delta) -> void :
	stateMachine._process_physics(delta)


func _process(delta) -> void :
	stateMachine._process_frame(delta)


func move(pPath : PackedVector2Array) -> void :
	path = pPath
	stateMachine.move()



@warning_ignore("native_method_override")
func get_class(): return "Infantry"


