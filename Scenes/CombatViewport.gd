extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in get_children():
		if i is Label:
			i.position += delta * 20
			i.scale.x -= delta
			i.scale.y -= delta
			if i.scale.x < 0:
				i.queue_free()


func numberPopup(damage : int, wasEnemy : bool):
	var num = Label.new()
	num.text = str(damage)
	num.position = Vector2(400, 300)
	
