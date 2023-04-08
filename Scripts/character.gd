extends HBoxContainer

class_name Character

@export var guyName : String
@export var frames : SpriteFrames

var health = 15

@onready var hpBar = %ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	%Label.text = guyName
	$Portrait/AnimSprite.sprite_frames = frames
	$Portrait/AnimSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hpBar.value = health
	
	health = clamp(health, 0, 15)
	
	if health <= 0:
		$Portrait/Dead.visible = true
		$Portrait/AnimSprite.frame = 0
		$Portrait/AnimSprite.stop()
	else:
		$Portrait/Dead.visible = false
		$Portrait/AnimSprite.play()
