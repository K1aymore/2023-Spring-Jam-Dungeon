extends MarginContainer

@onready var player : CharacterBody3D = %Player
@onready var playerCam : Camera3D = %PlayerCam

@onready var rotateTo := playerCam.rotation.y
@onready var moveTo := playerCam.position
var queuedMove

var deltaG : float

const MAPCAM_HEIGHT = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	print(playerCam)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltaG = delta
	
	check_move_turn_input()
	
	if get_parent().instantTurn:
		inst_turn()
	else:
		smooth_turn()
	
	if playerCam.rotation.y < 0:
		playerCam.rotation.y += PI * 2
	elif playerCam.rotation.y >= PI * 2:
		playerCam.rotation.y -= PI * 2
	
	if get_parent().instantMove:
		inst_move()
	else:
		smooth_move()
	
	%MapCam.position = playerCam.position
	%MapCam.position.y = MAPCAM_HEIGHT


func inst_turn():
	playerCam.rotation.y = rotateTo


func smooth_turn():
	var turnSpeed = clamp(deltaG * get_parent().turnSpeed, 0, 1)
	playerCam.rotation.y = lerp_angle(playerCam.rotation.y, rotateTo, turnSpeed)


func inst_move():
	playerCam.position = moveTo


func smooth_move():
	var moveSpeed = clamp(deltaG * get_parent().moveSpeed, 0, 1)
	playerCam.position = playerCam.position.lerp(moveTo, moveSpeed)


func check_move_turn_input():
	if Input.is_action_just_pressed("lturn"):
		rotateTo += PI/2
	if Input.is_action_just_pressed("rturn"):
		rotateTo -= PI/2
	
	if rotateTo < 0:
		rotateTo += PI * 2
	elif rotateTo >= PI * 2:
		rotateTo -= PI * 2
	
	var movement := Vector3.ZERO
	if Input.is_action_just_pressed("forward"):
		movement = calc_forw_move()
	
	if Input.is_action_just_pressed("backward"):
		movement = calc_forw_move()
		movement.z = -movement.z
		movement.x = -movement.x
	
	if Input.is_action_just_pressed("left"):
		movement = calc_forw_move()
		var temp = movement.x
		movement.x = movement.z
		movement.z = -temp
	
	if Input.is_action_just_pressed("right"):
		movement = calc_forw_move()
		var temp = movement.x
		movement.x = -movement.z
		movement.z = temp
	
	moveTo += movement



func calc_forw_move() -> Vector3:
	if is_zero_approx(rotateTo):
		return Vector3(0,0,-4)
	elif is_equal_approx(rotateTo, PI/2):
		return Vector3(-4,0,0)
	elif is_equal_approx(rotateTo, PI):
		return Vector3(0,0,4)
	elif is_equal_approx(rotateTo, (3*PI)/2):
		return Vector3(4,0,0)
	
	return Vector3.ZERO

