extends Node3D

var pos : Vector2
var orientaion : float
var vel : Vector2
var acceleration : Vector2
var maxForce := 1
var maxSpeed := 1
var pathRadius = 20

func _physics_process(delta) -> void  :
	pass


func updatePos(input : Vector2) -> void :
	var steeringForce := input.limit_length(maxForce)
	acceleration = steeringForce 
	vel = (vel + acceleration).limit_length(maxSpeed)
	
	position += Vector3(vel.x, position.y, vel.y)
	if input.length() < 0.001 :
		return
	rotation = Vector3(0, vel.angle(), 0)


func seek(des : Vector2) -> Vector2:
	var desiredVel = (des - vector3To2(position)).normalized() * maxSpeed
	var steeringForce = desiredVel - vel
	return steeringForce


func flee(des : Vector2) -> Vector2:
	var desiredVel = (vector3To2(position) - des).normalized() * maxSpeed
	var steeringForce = desiredVel - vel
	return steeringForce



func arrival(des : Vector2) -> Vector2 :
	var targetOffset := des - vector3To2(position)
	var distance := targetOffset.length()
	var slowingDistance := maxSpeed * (maxSpeed / maxForce + 1) / 2
	var rampedSpeed := maxSpeed * (distance / slowingDistance)
	var clippedSpeed = minf(rampedSpeed, maxSpeed)
	var desiredVel = clippedSpeed * targetOffset.normalized()
	var steeringForce = (desiredVel - vel)
	return steeringForce



func pathFollow(pPath : PackedVector2Array) -> Vector2 :
	var prediction := vel.normalized() * 30
	var predictPos := vector3To2(position) + prediction
	
	var normal : Vector2
	var target : Vector2
	var worldRecord = 10000
	
	for i in pPath.size() :
		var a = pPath[i]
		var b = pPath[(i + 1)% pPath.size()]
		
		var normalPoint : Vector2 = a + ((predictPos - a).project(b - a))
		var dir = b - a
		if (
			normalPoint.x < min(a.x, b.x) ||
			normalPoint.x > max(a.x, b.x) ||
			normalPoint.y < min(a.y, b.y) ||
			normalPoint.y > max(a.y, b.y)
		) :
			
			normalPoint = b
			a = pPath[(i + 1)% pPath.size()]
			b = pPath[(i + 2)% pPath.size()]
			dir = b - a
		
		var d = predictPos.distance_to(normalPoint)
		
		if d < worldRecord :
			worldRecord = d 
			normal = normalPoint
			
			dir = dir.normalized() * 25
			target = normal
			target += dir
	if (worldRecord > pathRadius) :
		return seek(target)
	else :
		return vel


func vector3To2(input : Vector3) -> Vector2 :
	return Vector2(input.x, input.z)
