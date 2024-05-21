extends State


var pos : Vector2
var orientaion : float
var desiredVel : Vector2 = Vector2.ZERO
var vel : Vector2
var acceleration : Vector2
var maxForce : float = 0.5
var maxSpeed : float = 1
var pathRadius = 8
var path : PackedVector2Array

var pathIdx := 0


@export var sentryState : State

func enter() -> void :
	path = parent.path


func exit() -> void :
	desiredVel = Vector2.ZERO
	pathIdx = 0
	pass


func _process_physics(_delta : float) -> State :
	updatePos(pathFollow(path))
	if desiredVel.length() < 0.001 :
		return sentryState
	return null



func updatePos(input : Vector2) -> void :
	var steeringForce := input.limit_length(maxForce)
	acceleration = steeringForce 
	vel = (vel + acceleration).limit_length(maxSpeed)
	parent.position += Vector3(vel.x, 0, vel.y)
	if input.length() < 0.001 :
		return
	parent.rotation = Vector3(0, vel.angle(), 0)



func seek(des : Vector2) -> Vector2:
	desiredVel = (des - vector3To2(parent.position)).normalized() * maxSpeed
	var steeringForce = desiredVel - vel
	return steeringForce



func arrival(des : Vector2) -> Vector2 :
	var targetOffset := des - vector3To2(parent.position)
	var distance := targetOffset.length()
	var slowingDistance := maxSpeed * (maxSpeed / maxForce + 1) / 2
	var rampedSpeed := maxSpeed * (distance / slowingDistance)
	var clippedSpeed = minf(rampedSpeed, maxSpeed)
	desiredVel = clippedSpeed * targetOffset.normalized()
	var steeringForce = (desiredVel - vel)
	return steeringForce


func pathFollow(pPath : PackedVector2Array) -> Vector2 :
	if (pPath.size() == 1) :
		return Vector2.ZERO
	if (pathIdx == pPath.size() - 2) :
		return arrival(pPath[-1])
	
	var predictPos := vector3To2(parent.position) + (vel.normalized() * 30)
	
	var target : Vector2
	var disFromMid : float
	
	var a = pPath[pathIdx % pPath.size()]
	var b = pPath[(pathIdx + 1) % pPath.size()]
	
	var normalPoint : Vector2 = a + ((predictPos - a).project(b - a))
	var dir = b - a
	
	disFromMid = predictPos.distance_to(normalPoint)
	
	dir = dir.normalized() * 40
	target = normalPoint
	target += dir
	
	var progress : Vector2 = (normalPoint - a)
	var length : Vector2 = (b - a)
	
	if (progress.length_squared() > length.length_squared() && progress.normalized() == length.normalized()) :
		pathIdx += 1 
	
	if (disFromMid > pathRadius) :
		return seek(target)
	else :
		predictPos = vector3To2(parent.position) + (Vector2.UP.rotated(parent.rotation.y + (0.5 * PI)) * 50)
		return seek(predictPos)



func vector3To2(input : Vector3) -> Vector2 :
	return Vector2(input.x, input.z)

