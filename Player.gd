extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	turn()
	move()



func turn():
	if Input.is_action_just_pressed("turn_left"):
		rotation.y += PI/2
	if Input.is_action_just_pressed("turn_right"):
		rotation.y -= PI/2
	
	if rotation.y < 0:
		rotation.y += PI * 2
	elif rotation.y >= PI * 2:
		rotation.y -= PI * 2
	
	rotation.y = snapped(rotation.y, PI/2)



func move():
	var movement := Vector3.ZERO
	if Input.is_action_just_pressed("forward") && !$RayForward.is_colliding():
		movement = calc_forw_move()
	
	if Input.is_action_just_pressed("backward") && !$RayBack.is_colliding():
		movement = calc_forw_move()
		movement.z = -movement.z
		movement.x = -movement.x
	
	if Input.is_action_just_pressed("left") && !$RayLeft.is_colliding():
		movement = calc_forw_move()
		var temp = movement.x
		movement.x = movement.z
		movement.z = -temp
	
	if Input.is_action_just_pressed("right") && !$RayRight.is_colliding():
		movement = calc_forw_move()
		var temp = movement.x
		movement.x = -movement.z
		movement.z = temp
	
	move_and_collide(movement)


func calc_forw_move() -> Vector3:
	if is_zero_approx(rotation.y):
		return Vector3(0,0,-4)
	elif is_equal_approx(rotation.y, PI/2):
		return Vector3(-4,0,0)
	elif is_equal_approx(rotation.y, PI):
		return Vector3(0,0,4)
	elif is_equal_approx(rotation.y, (3*PI)/2):
		return Vector3(4,0,0)
	
	return Vector3.ZERO

