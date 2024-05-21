extends PathFollow3D

var speed = 40
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress += speed * delta

func _input(event) -> void:
	if event is InputEventKey :
		if event.pressed && event.keycode == KEY_1 :
			progress += -50
