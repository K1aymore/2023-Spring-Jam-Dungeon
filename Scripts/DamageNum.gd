extends Marker2D

var num
var enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(num)
	$Anim.play("Hit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= delta * 200
	scale.x -= delta
	scale.y -= delta
	if scale.x < 0:
		queue_free()
