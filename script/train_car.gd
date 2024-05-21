extends Node3D

var next
var pre
var info : Node3D
var carLength := 54
var carDistance := 5
var speed := 20
var headPF : PathFollow3D
var tailPF : PathFollow3D
var mesh : Node3D
var pivot := Node3D.new()
@onready var railSystem = $'/root/root/rail system/Path3D'


func _init(carInfo : Node3D, fpre, fnext):
	info = carInfo
	next = fnext
	pre = fpre
	mesh = carInfo
	add_child(mesh)

func addNewPFNode() -> PathFollow3D :
	var pathFollowNode : PathFollow3D = PathFollow3D.new()
	pathFollowNode.rotation_mode = PathFollow3D.ROTATION_XYZ
	railSystem.add_child(pathFollowNode)
	return pathFollowNode

func _ready():
	if pre != null :
		headPF = addNewPFNode()
		headPF.progress = pre.tailPF.progress - carDistance
		tailPF = addNewPFNode()
		tailPF.progress = headPF.progress - carLength - carDistance
	else :
		headPF = addNewPFNode()
		headPF.progress_ratio = 0.5
		tailPF = addNewPFNode()
		tailPF.progress = headPF.progress - carLength - carDistance
	headPF.add_child(pivot)
	reparent(pivot, false)
	translate(Vector3(0, 0,-0.5 * carLength))
	rotate_y(deg_to_rad(-90))
	

func _process(delta):
	headPF.progress += speed * delta
	tailPF.progress += speed * delta
	pivot.look_at(tailPF.position)
