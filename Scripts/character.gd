extends HBoxContainer

class_name Character

@export var guyName : String
@export var texture : CompressedTexture2D

var health = 15


# Called when the node enters the scene tree for the first time.
func _ready():
	%Label.text = guyName
	$TextureRect.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%ProgressBar.value = health
	
	health = clamp(health, 0, 15)
