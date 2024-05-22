extends Node


const RAY_LENGTH := 1000

@onready var camera := $"../Camera3D"
@onready var grid := $"../GridMap"
@onready var mapTool := $"../MapGen Tool"
var from : Vector3
var to : Vector3
var selectedUnit : Array[CharacterBody3D] 
var destination : Vector3i 
var rayCastResult : Dictionary
var gridFrom : Vector2i = Vector2i(0,0)
var gridTo : Vector2i = Vector2i(0,0)

var squadIndexer : Array[Dictionary] = []
var unitIndexer : Array = []
var vehicleIndexer : Array = []

@export var militia : Resource



func _input(event) :
	if event is InputEventMouseButton && event.is_pressed():
		from = camera.project_ray_origin(event.position)
		to = from + camera.project_ray_normal(event.position) * RAY_LENGTH
		_physics_process(event.button_index)
		mouseAction(event.button_index)
	if event is InputEventKey :
		if event.keycode == KEY_F  && event.is_pressed() :
			var newUnit := createInfantry(militia)
			newUnit.position = Vector3(randi_range(250, 400), 6, randi_range(200, 300))
		if event.keycode == KEY_G  && event.is_pressed() :
			makeSquad(get_tree().get_nodes_in_group("selected"))


func _ready():
	set_physics_process(false)
	await get_tree().process_frame
	#debugging()



func createInfantry(type : Resource) -> Node3D :
	var unit : Infantry = militia.instantiate()
	add_child(unit)
	return unit



func _physics_process(_delta):
	var space_state = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	rayCastResult = space_state.intersect_ray(query)



func mouseAction(button_pressed : int) -> void :
	var result : PackedVector2Array = []
	gridFrom = Vector2i(grid.local_to_map(grid.to_local($CharacterBody3D.position)).x, grid.local_to_map(grid.to_local($CharacterBody3D.position)).z)
	if button_pressed == 2 :
		gridTo = Vector2i(grid.local_to_map(grid.to_local(rayCastResult['position'])).x, grid.local_to_map(grid.to_local(rayCastResult['position'])).z)
		result = getPath(gridFrom, gridTo)
		get_tree().call_group("selected", "move", result)




func getPath(pFrom : Vector2i, pTo : Vector2i) -> PackedVector2Array :
	var result : PackedVector2Array = []
	result = Array(mapTool.navGrid.get_point_path(pFrom, pTo)).map(func(input : Vector2i) : return (input + Vector2i(mapTool.navGrid.cell_size / 2)))
	return result



func groupNavRand(input : PackedVector2Array) -> Array[PackedVector2Array] :
	var result : Array[PackedVector2Array] = []
	return result



func gather(squadNum : int ) -> Array[PackedVector2Array] :
	var result : Array[PackedVector2Array] = []
	return result



func makeSquad(members : Array[Node]) -> void :
	var squad : Dictionary = {
		"type" : members[0].stats.type,
		"members" : members
	}
	members.map(
		func(input) :
			input.stats.squad = squadIndexer.size()
	)
	squadIndexer.append(squad)
	#print(squadIndexer[0]["members"][0].stats.squad)
	#print(squadIndexer)

