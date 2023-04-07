extends Control

var instantTurn := false
var instantMove := false

var turnSpeed := 10
var moveSpeed := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.setMode($Menu.Mode.MAIN)


func _process(delta):
	pass


func play():
	$Menu.setMode($Menu.Mode.HIDDEN)
