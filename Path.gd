extends Path3D


@onready var grid = $"../../GridMap"
var currentASide
var startingPathTitle : Vector3i = Vector3(0,1,0)
var currentTile : Vector3i = startingPathTitle
var currentPathPos : Vector3 
enum A_SIDE {UP, DOWN, LEFT, RIGHT} 


# Called when the node enters the scene tree for the first time.
func _ready():
	currentPathPos = grid.map_to_local(startingPathTitle) + Vector3(-8, 0, 0)
	
	startPos()



# caculate starting position of path and starting paths segment (right now only do 3 straith tile)
func startPos():
	railAndPath(4, 16, Vector3i(1, 0, 0), 16)
	currentASide = A_SIDE.LEFT


#constructing the path logically from current path
func constructPath(index : int , ori : int):
	var tileL = grid.cell_size.x
	if index == 4:
		match ori:
			10 :
				updatePos(Vector3(0, 0, -tileL))
			0 :
				updatePos(Vector3(0, 0, tileL))
			16 :
				updatePos(Vector3(tileL, 0, 0))
			22 :
				updatePos(Vector3(-tileL, 0, 0))

	
	elif index == 9 :
		match ori:
			10 :
				if currentASide == A_SIDE.DOWN :
					updatePos(Vector3(tileL * 2.5, 0, -tileL * 2.5), Vector3(0, 0, tileL * 2.5))
				else : #RIGHT
					updatePos(Vector3(-tileL * 2.5, 0, tileL * 2.5), Vector3(tileL * 2.5, 0, 0))
			0 :
				if currentASide == A_SIDE.UP :
					updatePos(Vector3(-tileL * 2.5, 0, tileL * 2.5), Vector3(0, 0, -tileL * 2.5))
				else : #LEFT
					updatePos(Vector3(tileL * 2.5, 0, -tileL * 2.5), Vector3(-tileL * 2.5, 0, 0))
			16 :
				if currentASide == A_SIDE.LEFT :
					updatePos(Vector3(tileL * 2.5, 0, tileL * 2.5), Vector3(-tileL * 2.5, 0, 0))
				else : #DOWN
					updatePos(Vector3(-tileL * 2.5, 0, -tileL * 2.5), Vector3(0, 0, tileL * 2.5))
			22 :
				if currentASide == A_SIDE.RIGHT :
					updatePos(Vector3(-tileL * 2.5, 0, -tileL * 2.5), Vector3(tileL * 2.5, 0, 0))
				else : #UP
					updatePos(Vector3(tileL * 2.5, 0, tileL * 2.5), Vector3(0, 0, -tileL * 2.5))


func updatePos( pos : Vector3, controlPoint := Vector3(Vector3.ZERO)) :
	
	currentPathPos += pos
	curve.add_point(currentPathPos, controlPoint)


#constructing the path graphically from current path
func addRail(index : int, side : int):
	grid.set_cell_item( Vector3(currentTile.x, currentTile.y, currentTile.z), index,side)


func railAndPath(index : int, side : int, advancedTiles: Vector3i, recursion : int = 1) :
	for i in recursion:
		addRail(index, side)
		constructPath(index, side)
		currentTile += advancedTiles


func _input(event):
	if event is InputEventKey :
		if event.pressed && event.keycode == KEY_LEFT :
			if currentASide == A_SIDE.RIGHT:
				currentASide = A_SIDE.RIGHT
				railAndPath(4, 22, Vector3i(-1, 0, 0))
			elif currentASide == A_SIDE.UP:
				currentASide = A_SIDE.RIGHT
				railAndPath(5, 10, Vector3i(0, 0, 1))
				railAndPath(6, 10, Vector3i(-1, 0, 0))
				railAndPath(7, 10, Vector3i(0, 0, 1))
				railAndPath(8, 10, Vector3i(-1, 0, 0))
				railAndPath(9, 10, Vector3i(-1, 0, 0))
			elif currentASide == A_SIDE.DOWN:
				currentASide = A_SIDE.RIGHT
				railAndPath(9, 22, Vector3i(0, 0, -1))
				railAndPath(8, 22, Vector3i(-1, 0, 0))
				railAndPath(7, 22, Vector3i(0, 0, -1))
				railAndPath(6, 22, Vector3i(-1, 0, 0))
				railAndPath(5, 22, Vector3i(-1, 0, 0))
		elif event.pressed && event.keycode == KEY_RIGHT :
			if currentASide == A_SIDE.LEFT:
				currentASide = A_SIDE.LEFT
				railAndPath(4, 16, Vector3i(1, 0, 0))
			elif currentASide == A_SIDE.UP:
				currentASide = A_SIDE.LEFT
				railAndPath(9, 16, Vector3i(0, 0, 1))
				railAndPath(8, 16, Vector3i(1, 0, 0))
				railAndPath(7, 16, Vector3i(0, 0, 1))
				railAndPath(6, 16, Vector3i(1, 0, 0))
				railAndPath(5, 16, Vector3i(1, 0, 0))
			elif currentASide == A_SIDE.DOWN:
				currentASide = A_SIDE.LEFT
				railAndPath(5, 0, Vector3i(0, 0, -1))
				railAndPath(6, 0, Vector3i(1, 0, 0))
				railAndPath(7, 0, Vector3i(0, 0, -1))
				railAndPath(8, 0, Vector3i(1, 0, 0))
				railAndPath(9, 0, Vector3i(1, 0, 0))
		elif event.pressed && event.keycode == KEY_UP :
			if currentASide == A_SIDE.LEFT:
				currentASide = A_SIDE.DOWN
				railAndPath(9, 10, Vector3i(1, 0, 0))
				railAndPath(8, 10, Vector3i(0, 0, -1))
				railAndPath(7, 10, Vector3i(1, 0, 0))
				railAndPath(6, 10, Vector3i(0, 0, -1))
				railAndPath(5, 10, Vector3i(0, 0, -1))
			elif currentASide == A_SIDE.RIGHT:
				currentASide = A_SIDE.DOWN
				railAndPath(5, 16, Vector3i(-1, 0, 0))
				railAndPath(6, 16, Vector3i(0, 0, -1))
				railAndPath(7, 16, Vector3i(-1, 0, 0))
				railAndPath(8, 16, Vector3i(0, 0, -1))
				railAndPath(9, 16, Vector3i(0, 0, -1))
			elif currentASide == A_SIDE.DOWN:
				currentASide = A_SIDE.DOWN
				railAndPath(4, 10, Vector3i(0, 0, -1))
		elif event.pressed && event.keycode == KEY_DOWN :
			if currentASide == A_SIDE.LEFT:
				currentASide = A_SIDE.UP
				railAndPath(5, 22, Vector3i(1, 0, 0))
				railAndPath(6, 22, Vector3i(0, 0, 1))
				railAndPath(7, 22, Vector3i(1, 0, 0))
				railAndPath(8, 22, Vector3i(0, 0, 1))
				railAndPath(9, 22, Vector3i(0, 0, 1))
			elif currentASide == A_SIDE.RIGHT:
				currentASide = A_SIDE.UP
				railAndPath(9, 0, Vector3i(-1, 0, 0))
				railAndPath(8, 0, Vector3i(0, 0, 1))
				railAndPath(7, 0, Vector3i(-1, 0, 0))
				railAndPath(6, 0, Vector3i(0, 0, 1))
				railAndPath(5, 0, Vector3i(0, 0, 1))
			elif currentASide == A_SIDE.UP:
				currentASide = A_SIDE.UP
				railAndPath(4, 0, Vector3i(0, 0, 1))
