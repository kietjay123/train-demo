extends Node
###processing mamager for every train car(may be dont need)#####
const trainCar = preload("res://script/train_car.gd")
var normalCar : Array = []
var headCar : Array = []


func _ready():
	pass # Replace with function body.


func addNormalCar(car : trainCar) -> void : 
	normalCar.append(car)

func removeNormalCar(car : trainCar) -> void :
	normalCar.erase(car)


func addHeadCar(car : trainCar) -> void :
	headCar.append(car)

func removeHeadCar(car : trainCar) -> void :
	headCar.erase(car)



func runNormalCarUpdate() -> void :
	for i in normalCar :
		i.update() if i.has_method("update") else push_warning('wat')

func runHeadCarUpdate() -> void :
	for i in headCar :
		i.update() if i.has_method("update") else push_warning('wat')



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	runNormalCarUpdate()
	runHeadCarUpdate()
