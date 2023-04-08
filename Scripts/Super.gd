extends Control

var instantTurn := false
var instantMove := false

var turnSpeed := 10
var moveSpeed := 10

@onready var Mode = $Menu.Mode

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.setMode($Menu.Mode.MAIN)
	$Menu.visible = true
	$Anim.play("RESET")
	$Game.restart()
	$Game/Music.play()
	get_tree().paused = false


func _process(delta):
	if Input.is_action_just_pressed("escape") && !$Anim.is_playing():
		match $Menu.mode:
			Mode.MAIN:
				$Anim.play("menuHide")
			Mode.OPTIONS:
				$Menu.setMode($Menu.Mode.MAIN)
			Mode.HIDDEN:
				$Anim.play("menuShow")


func play():
	$Menu.setMode($Menu.Mode.HIDDEN)
	get_tree().paused = false


func win():
	$Game.restart()
	play()


func lose():
	$Menu.setMode(Mode.HIDDEN)
	$Game.restart()
	$Game/Music.play()
	get_tree().paused = false
