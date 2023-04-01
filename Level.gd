extends Node3D

var map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generateMap():
	pass


func tileExists(pos : Vector2) -> bool:
	return map.has(pos)
