extends "res://train manager.gd"


var weaponData := []
var carNameIndex := 0




# Called when the node enters the scene tree for the first time.
func _ready():
	loadCSV()
	construct(['head'])
	construct(['head'])


func construct(config : Array[String]) -> void :
	var x := config[0]
	config.remove_at(0)
	match x :
		"normal":
			constructWeaponPlat(config)
		"weaponPlatform":
			constructNormal(config)
		"storage":
			constructStorage()
		"head" :
			constructHead()


func constructWeaponPlat(config : Array[String]) -> void :
	add_child((load("res://asset/wPlat.glb") as PackedScene).instantiate())
	var index := 0
	for i in config :
		addWPlat(index, i)
		index += 1


func constructNormal(config : Array[String]) -> void :
	add_child((load("res://asset/normal.gltf") as PackedScene).instantiate())
	var index := 0
	for i in config :
		addWMount(index, i)
		index += 1


func constructStorage() -> void :
	pass


func constructHead() -> void :
	var vhead = (load("res://asset/head.gltf") as PackedScene).instantiate()
	createBoilerNode(vhead)


func addWMount(pos : int, type : String) -> void :
	pass


func addWPlat(pos : int, type : String) -> void :
	pass


func loadCSV() -> void :
	var file := FileAccess.open("res://data/Data.csv", FileAccess.READ)
	while !file.eof_reached() :
		var x := file.get_csv_line(",")
		weaponData = Array(x)
	file.close()

func createBoilerNode(mesh : Node3D) -> Node3D :
	var parentNode = add(mesh)
	parentNode.name = 'Car_' + str(carNameIndex)
	add_child(parentNode)
	carNameIndex += 1
	return parentNode
