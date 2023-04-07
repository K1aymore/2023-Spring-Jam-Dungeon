extends Control

@onready var player : CharacterBody3D = $Player
@onready var playerCam : Camera3D = get_node("%PlayerCam")

var deltaG : float

const MAPCAM_HEIGHT = 20

var Level := preload("res://Scenes/level.tscn")
var level : Level

@onready var combatFade = %CombatFade

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
var enemy : AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().root.ready
	newLevel()
	startExplore()



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
	
	if state == State.EXPLORE:
		if level.getTile(player.position).isCombatTile:
			startCombat()
	
	if state == State.COMBAT:
		if enemy != null:
			enemy.position.y = lerp(enemy.position.y, 280.0, delta * 3)
		combatFade.add_theme_stylebox_override("Panel", combatFade.get_theme_stylebox("Panel"))
		if turn == Turn.PLAYER:
			pass
		if turn == Turn.ENEMY:
			pass
		if enemy.health < 0:
			level.getTile(player.position).isCombatTile = false
			enemy.scale = enemy.scale.move_toward(Vector2.ZERO, delta * 10)
			if enemy.scale.x < 0.5:
				startExplore()



func startExplore():
	if enemy != null:
		enemy.queue_free()
	
	state = State.EXPLORE
	combatFade.visible = false


func startCombat():
	state = State.COMBAT
	turn = Turn.PLAYER
	enemy = Enemy.instantiate()
	
	enemy.position = Vector2(370, 840)
	enemy.z_index = 1
	
	%CombatViewport.add_child(enemy)
	combatFade.visible = true



func playerAttack(damage : int):
	if turn != Turn.PLAYER || state != State.COMBAT || enemy == null:
		return
	
	enemy.health -= damage






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
	var turnSpeed = deltaG * get_parent().turnSpeed
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
	var moveSpeed = deltaG * get_parent().moveSpeed
	playerCam.position = playerCam.position.lerp(player.position, moveSpeed)



func _on_player_blocked():
	print("Blocked")
	newLevel()


func _on_attack_pressed():
	playerAttack(4)
