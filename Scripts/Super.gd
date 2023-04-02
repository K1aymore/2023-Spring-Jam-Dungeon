extends Control

var instantTurn := false
var instantMove := false

var turnSpeed := 10
var moveSpeed := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$Menu.setMode($Menu.Mode.MAIN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = true
		$Menu.setMode($Menu.Mode.MAIN)


func play():
	get_tree().paused = false
	$Menu.setMode($Menu.Mode.HIDDEN)
