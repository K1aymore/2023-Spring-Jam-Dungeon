extends AnimatedSprite3D

class_name Enemy

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
	position = position.move_toward(Vector3(position.x, 1.9, position.z), delta * 5)


