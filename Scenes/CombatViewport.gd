extends SubViewport

var dmgNumScene = preload("res://Scenes/DamageNum.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in get_children():
		if i is Marker2D:
			i.position.y -= delta * 200
			i.scale.x -= delta
			i.scale.y -= delta
			if i.scale.x < 0:
				i.queue_free()


func numberPopup(damage : int, wasEnemy : bool):
	var num = dmgNumScene.instantiate()
	num.num = str(damage)
	num.position = Vector2(400, 200)
	
	add_child(num)
