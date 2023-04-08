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
	ENEMY,
	DELAY
}

var Enemy := preload("res://Scenes/enemy.tscn")
var enemy : AnimatedSprite2D

var character = preload("res://Scenes/character.tscn")
var characters : Array[Character] = []

var isDefending := false
var enemiesKilled := 0

var camPos : Vector3
var camShake := 0.0


var dmgNumScene = preload("res://Scenes/DamageNum.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().root.ready
	
	for guy in %Characters.get_children():
		characters.append(guy)
	


func restart():
	newLevel()
	startExplore()
	
	for i in characters:
		i.health = 15
	
	isDefending = false
	enemiesKilled = 0
	state = State.EXPLORE
	turn = Turn.PLAYER


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
	
	var curTile = level.getTile(player.position)
	
	if camShake < 0:
		var shakeOffset = Vector3(camShake * 200, 0, 0).rotated(Vector3.FORWARD, playerCam.rotation.y)
		playerCam.position = camPos + shakeOffset
		camShake -= delta
	
	if state == State.EXPLORE:
		curTile.explore()
		if curTile.isCombatTile:
			startCombat()
	
	if state == State.COMBAT:
		if enemy != null:
			enemy.position.y = lerp(enemy.position.y, 280.0, delta * 3)
			$EnemyStats/ProgressBar.value = enemy.health
		
		if enemy != null && enemy.health <= 0:
			curTile.isCombatTile = false
			enemy.scale = enemy.scale.move_toward(Vector2.ZERO, delta * 10)
			if enemy.scale.x < 0.5:
				enemyKilled()




func startExplore():
	if enemy != null:
		enemy.queue_free()
	
	state = State.EXPLORE
	$Anim.play("endCombat")
	$EnemyStats.visible = false


func startCombat():
	state = State.COMBAT
	turn = Turn.PLAYER
	enemy = Enemy.instantiate()
	
	enemy.position = Vector2(370, 840)
	
	%CombatViewport.add_child(enemy)
	$Anim.play("startCombat")
	$EnemyStats/ProgressBar.max_value = enemy.health
	$EnemyStats.visible = true



func switchTurn():
	$TurnDelay.stop()
	if enemy == null || enemy.health == 0:
		turn = Turn.PLAYER
		return
	
	if turn == Turn.ENEMY:
		turn = Turn.ENEMY
		enemyAttack()
	
	elif turn == Turn.DELAY:
		turn = Turn.PLAYER




func playerAttack(damage : int):
	if turn != Turn.PLAYER || state != State.COMBAT || enemy == null:
		return
	
	$PlayerAttack.play()
	isDefending = false
	
	damage += randi_range(0, 3)
	enemy.health -= damage
	turn = Turn.ENEMY
	
	$TurnDelay.start()
	%CombatViewport.numberPopup(damage, false)


func playerDefend():
	if turn != Turn.PLAYER || state != State.COMBAT || enemy == null:
		return
	
	isDefending = true
	turn = Turn.ENEMY
	$TurnDelay.start()


func enemyAttack():
	screenShake()
	if isDefending:
		$Defend.play()
		numberPopup(0, 0)
		turn = Turn.DELAY
		$TurnDelay.start()
		return
	
	$EnemyAttack.play()
	var hasAttacked = false
	
	for i in characters.size():
		if !hasAttacked && characters[i].health > 0:
			var damage = enemy.damage + randi_range(0, 3)
			characters[i].health -= damage
			characters[i].hpBar.value = characters[i].health
			numberPopup(damage, i)
			hasAttacked = true
	
	if characters[characters.size()-1].health <= 0:
		lose()
	
	turn = Turn.DELAY
	$TurnDelay.start()




func enemyKilled():
	$EnemyDeath.play()
	startExplore()
	enemiesKilled += 1
	
	var rand = randi_range(0, 2)
	
	if enemiesKilled >= 6 || (enemiesKilled >= 3 && rand == 0):
		win()
#	var hasHealed = false
#	for i in range(characters.size()-1, -1, -1):
#		if characters[i].health < 15 && !hasHealed:
#			characters[i].health += randi_range(5, 7)
#			hasHealed = true



func screenShake():
	camPos = playerCam.position
	camShake = 1



func numberPopup(damage : int, guyIndex : int):
	var num = dmgNumScene.instantiate()
	num.num = str(damage)
	num.global_position = characters[guyIndex].global_position
	num.position += Vector2(100, 100)
	
	add_child(num)


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


func _on_defend_button_pressed():
	playerDefend()



func lose():
	get_tree().paused = true
	$Music.stop()
	($"../Anim" as AnimationPlayer).play("lose")


func win():
	get_tree().paused = true
	($"../Anim" as AnimationPlayer).play("win")


