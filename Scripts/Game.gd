extends MarginContainer

@onready var player : CharacterBody3D = $Player
@onready var playerCam : Camera3D = get_node("%PlayerCam")

var deltaG : float

const MAPCAM_HEIGHT = 20

var Level := preload("res://Scenes/level.tscn")
var level : Level


var state : State = State.EXPLORE
enum State {
	EXPLORE,
	COMBAT,
}


var turn : Turn
enum Turn {
	PLAYER,
	ENEMY
}

var Enemy := preload("res://Scenes/enemy.tscn")
var enemy : Enemy


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().root.ready
	newLevel()



func newLevel():
	if level is Level:
		remove_child(level)
	level = Level.instantiate()
	add_child(level)
	
	var startPos = level.startTile.position
	startPos.y += 2
	player.position = startPos
	player.rotation.y = (3*PI)/2
	playerCam.transform = player.transform


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	deltaG = delta
	
	turnCam()
	moveCam()
	
	if state == State.EXPLORE && level.getTile(player.position).isCombatTile:
		startCombat()
	
	



func startCombat():
	state = State.COMBAT
	turn = Turn.PLAYER
	enemy = Enemy.instantiate()
	
	enemy.position = player.position + Vector3.FORWARD.rotated(Vector3.UP, player.rotation.y)
	
	enemy.position.y = -2
	add_child(enemy)










func turnCam():
	if get_parent().instantTurn:
		instTurn()
	else:
		smoothTurn()
	
	if playerCam.rotation.y < 0:
		playerCam.rotation.y += PI * 2
	elif playerCam.rotation.y >= PI * 2:
		playerCam.rotation.y -= PI * 2


func instTurn():
	playerCam.rotation.y = player.rotation.y

func smoothTurn():
	var turnSpeed = clamp(deltaG * get_parent().turnSpeed, 0, 1)
	playerCam.rotation.y = lerp_angle(playerCam.rotation.y, player.rotation.y, turnSpeed)




func moveCam():
	if get_parent().instantMove:
		instMove()
	else:
		smoothMove()
	
	%MapCam.position = playerCam.position
	%MapCam.position.y = MAPCAM_HEIGHT


func instMove():
	playerCam.position = player.position

func smoothMove():
	var moveSpeed = clamp(deltaG * get_parent().moveSpeed, 0, 1)
	playerCam.position = playerCam.position.lerp(player.position, moveSpeed)



func _on_player_blocked():
	print("Blocked")
	newLevel()
