@tool

extends Node

@onready var gridMap := $"../GridMap"

var navGrid : AStarGrid2D = AStarGrid2D.new()


func setGenerate( _state : bool ) -> void :
	Generate()





@export var generate := false : set = setGenerate

func Generate() -> void :
	reset()



@export var size := 256 : set = setSize 

func setSize( s : int ) -> void :
	size = s
	gradient1.set_width(size)
	gradient1.set_height(size)



@export_range(-1, 1) var seaLevel := -0.2 : set = setSeaLevel

func setSeaLevel( s : float ) -> void :
	seaLevel = s



@export_range(-1, 1) var sandLevel : float = -0.1 : set = setSandLevel

func setSandLevel( s : float ) -> void :
	sandLevel = s


@export var noise : FastNoiseLite
@export var gradient1 : GradientTexture2D

func reset():
	gradient1.set_width(size)
	gradient1.set_height(size)
	await get_tree().process_frame
	gridMap.clear()
	var voxelvalue : float 
	var graImg := gradient1.get_image()
	generateAStarGrid()
	for x in range(size) :
		for y in range(size) :
			voxelvalue = noise.get_noise_2d(x, y) - graImg.get_pixel(x, y).r
			if voxelvalue < seaLevel :
				gridMap.set_cell_item(Vector3i(x, 0, y), 0)
				navGrid.set_point_solid(Vector2i(x,y))
			elif voxelvalue < sandLevel :
				gridMap.set_cell_item(Vector3i(x, 0, y), 1)
			else :
				gridMap.set_cell_item(Vector3i(x, 0, y), 2)
	gridMap.set_bake_navigation(false)


func generateAStarGrid() -> void :
	navGrid.region = Rect2i(0, 0, size, size)
	navGrid.cell_size = Vector2i(gridMap.cell_size.x, gridMap.cell_size.x)
	navGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	navGrid.jumping_enabled = true
	navGrid.update()


func _ready():
	reset()


