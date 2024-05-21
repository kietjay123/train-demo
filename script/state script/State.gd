class_name State

extends Node

var parent : Node3D

func enter() -> void :
	pass

func exit() -> void :
	pass

func _process_input(_event : InputEvent) -> State:
	return null

func _process_frame(_delta: float) -> State :
	return null

func _process_physics(_delta: float) -> State:
	return null
