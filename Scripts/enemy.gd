extends AnimatedSprite2D


var health : int

var type : Mob

enum Mob {
	GRABIKA,
	
}


# Called when the node enters the scene tree for the first time.
func _ready():
	
	match type:
		Mob.GRABIKA:
			health = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


