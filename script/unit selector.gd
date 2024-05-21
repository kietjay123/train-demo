extends Node2D


@onready var camera := get_viewport().get_camera_3d()
var from : Vector3
var to : Vector3
const RAY_LENGTH := 1000
var leftButtonHeld : bool = false
var pos : Vector2
var end : Vector2
var detectorFrom : Vector2
var detectorTo : Vector2
var selected : Array
var dragThreshold := 4


func _input(event) :
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed :
		if leftButtonHeld == false :
			pos = get_global_mouse_position()
			var result : Dictionary = createRay()
			detectorFrom = Vector2(result.position.x, result.position.z) 
			singleSelection()
		leftButtonHeld = true
		end = get_global_mouse_position()
	elif event is InputEventMouseButton && event.button_index == 1 && !event.pressed :
		if leftButtonHeld == true :
			if ((end - pos).length() > dragThreshold) :
				var result : Dictionary = createRay()
				detectorTo = Vector2(result.position.x, result.position.z) 
				selectArea()
			else :
				pass
		leftButtonHeld = false
	elif event is InputEventMouseMotion :
		if leftButtonHeld == true :
			end = get_global_mouse_position()
		
	if event is InputEventMouseButton && event.button_index == 1 && event.double_click :
		if (true if !selected.is_empty() else false) :
			typeSelection(selected[0])
	
	queue_redraw()



func _draw():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) :
		if ((end - pos).length() > dragThreshold) :
			draw_rect(Rect2(pos, end - pos ), Color.WHITE, false, 2)
	else :
		pass




func createRay(mask : int = 0b1) -> Dictionary :
	from = camera.project_ray_origin(get_global_mouse_position())
	to = from + camera.project_ray_normal(get_global_mouse_position()) * RAY_LENGTH
	var space_state = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = mask
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	return result



func selectArea() -> void :
	var space_state := camera.get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.collide_with_areas = true
	var temp := detectorFrom + ((detectorTo - detectorFrom) / 2)
	query.transform = Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(temp.x, 0, temp.y))
	var shape := BoxShape3D.new()
	shape.size = Vector3(abs((detectorTo - detectorFrom).x), 0, abs((detectorTo - detectorFrom).y))
	query.shape = shape
	query.collision_mask = 0b10
	
	selected = space_state.intersect_shape(query).map(func(dict): return dict.collider.get_parent())
	resetSelectedGroup()



func singleSelection() -> void :
	from = camera.project_ray_origin(get_global_mouse_position())
	to = from + camera.project_ray_normal(get_global_mouse_position()) * RAY_LENGTH
	var space_state = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 0b10
	query.collide_with_areas = true
	
	selected = [] if space_state.intersect_ray(query).is_empty() else [space_state.intersect_ray(query).collider.get_parent()]
	resetSelectedGroup()


func typeSelection(type) -> void :
	var polygonPointArray : PackedVector3Array = []
	
	polygonPointArray.append(typeSelectionRCResultPos(Vector2(0, 0)))
	polygonPointArray.append(typeSelectionRCResultPos(Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), 0)))
	polygonPointArray.append(typeSelectionRCResultPos(Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))))
	polygonPointArray.append(typeSelectionRCResultPos(Vector2(0, ProjectSettings.get_setting("display/window/size/viewport_height"))))
	
	var space_state = camera.get_world_3d().direct_space_state
	var query2 = PhysicsShapeQueryParameters3D.new()
	query2.collide_with_areas = true
	query2.transform = Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3.ZERO)
	var shape = createCollisionShape(polygonPointArray)
	query2.shape = shape
	query2.collision_mask = 0b10
	var preSelected = space_state.intersect_shape(query2).map(func(dict): return dict.collider.get_parent())
	
	selected = preSelected.filter(func(a): return a.get_class() == type.get_class())
	resetSelectedGroup()


func typeSelectionRCResultPos(pPos : Vector2) -> Vector3 :
	var result : Vector3
	var space_state = camera.get_world_3d().direct_space_state
	var query : PhysicsRayQueryParameters3D
	
	var Pfrom = camera.project_ray_origin(pPos)
	var Pto = Pfrom + camera.project_ray_normal(pPos) * RAY_LENGTH
	query = PhysicsRayQueryParameters3D.create(Pfrom, Pto)
	query.collision_mask = 0b1
	query.collide_with_areas = true
	
	result = space_state.intersect_ray(query).position
	
	return result



func createCollisionShape(polygonPointArray : PackedVector3Array) -> ConvexPolygonShape3D :
	var result := ConvexPolygonShape3D.new()
	result.points = polygonPointArray
	return result


func resetSelectedGroup() -> void :
	var temp2 : Array[Node] = get_tree().get_nodes_in_group("selected")
	temp2.map(func(a): a.remove_from_group("selected"))
	selected.map(
		func(a):
			a.add_to_group("selected")
			print(a)
	)



func _ready():
	set_physics_process(false)



func clearSelection() -> void :
	selected.clear()



