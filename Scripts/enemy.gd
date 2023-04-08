extends AnimatedSprite2D

@onready var sprite = self

var health : int
var damage : int

var type : Mob

enum Mob {
	GRABIKA,
	APPLEY,
	MANTISTAUR,
	MONKEY
}


# Called when the node enters the scene tree for the first time.
func _ready():
	type = randi_range(0, Mob.size()-1)
	
	if type == Mob.GRABIKA:
		sprite.scale = Vector2(3.7, 3.7)
	else:
		sprite.scale = Vector2(2.5, 2.5)
	
	match type:
		Mob.GRABIKA:
			health = 10
			damage = 5
			sprite.sprite_frames = load("res://Assets/SpriteFrames/Grabika.tres")
		Mob.APPLEY:
			health = 20
			damage = 3
			sprite.sprite_frames = load("res://Assets/SpriteFrames/Appley.tres")
		Mob.MANTISTAUR:
			health = 6
			damage = 8
			sprite.sprite_frames = load("res://Assets/SpriteFrames/Mantistaur.tres")
		Mob.MONKEY:
			health = 8
			damage = 6
			sprite.sprite_frames = load("res://Assets/SpriteFrames/Monkey.tres")
	
	health += randi_range(0, 3)
	damage += randi_range(0, 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


