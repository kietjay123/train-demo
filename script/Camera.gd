extends Camera3D


@onready var screenSize : Vector2 = get_viewport().size
@export var camSpeed : float = 300
var isMoving : bool = false
var direction : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	# detect mouse on screen border 
	if event is InputEventMouseMotion :
		var mousePos : Vector2 = (screenSize - event.position) / screenSize
		if mousePos.x <= 0.01 || mousePos.x >= 0.99 || mousePos.y <= 0.01 || mousePos.y >= 0.99 :
			isMoving = true
			
			direction = (event.position - screenSize / 2).normalized()
		else :
			isMoving = false



func moveCam(way : Vector3):
	self.translate(way)
	



func _process(delta):
	if isMoving == true :
		moveCam(Vector3(direction.x * camSpeed * delta,0 , direction.y * camSpeed * delta).rotated(Vector3(1, 0, 0), deg_to_rad(45)))
