extends CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var wallImage = Image.load_from_file("Assets/wall.png")
	$Sprite3D.texture = ImageTexture.create_from_image(wallImage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
