extends Node3D


const OFFSET = Vector2(0, -4)

const TILE_NUM = 50
var counter := 0
var openEnds := 0

var startTile := Tile.new()

var lastTile : Tile

const DEBUG = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var floorImage = Image.load_from_file("Assets/floor.png")
	$Floor.texture = ImageTexture.create_from_image(floorImage)
	
	var roofImage = Image.load_from_file("Assets/roof.png")
	$Roof.texture = ImageTexture.create_from_image(roofImage)
	
	
	startTile.setType(Tile.Type.START)
	add_child(startTile)
	openEnds += 1
	
	lastTile = startTile
	
	if DEBUG == false:
		generateMap(startTile)


func _process(delta):
	if Input.is_action_just_pressed("space") && DEBUG == true:
		addTile(lastTile)


func generateMap(tile : Tile):
	counter += 1
	for i in tile.maxTiles:
		var newTile = addTile(tile)
		
		generateMap(newTile)



func addTile(tile : Tile) -> Tile:
	var newTile = genTile(tile)
	
	tile.connectTile(newTile)
	
	add_child(newTile)
	openEnds += newTile.maxTiles - 1
	
	lastTile = newTile
	return newTile



func genTile(tile : Tile) -> Tile:
	var newTile := Tile.new()
	
	var goodTile := false
	var whileCounter := 0
	
	while !goodTile:
		newTile.setType(genTileType())
		whileCounter += 1
		goodTile = true
		for o in newTile.tileOffsets:
			if tileExists(tile.nextPos() + Vector3(o).rotated(Vector3.UP, tile.nextRot())):
				goodTile = false
		
		if whileCounter > 100:
			newTile.setType(Tile.Type.EMPTY)
			goodTile = true
	
	return newTile


func genTileType() -> Tile.Type:
	if counter > TILE_NUM:
		return Tile.Type.END
	elif openEnds <= 1:
		return randTileType(false)
	elif counter > TILE_NUM/openEnds:
		return Tile.Type.END
	else:
		return randTileType(true)


func randTileType(canEnd : bool) -> Tile.Type:
	var rand : int
	
	if canEnd:
		rand = randi_range(0, 6)
	else:
		rand = randi_range(0, 4)
	
	match rand:
		0:
			return Tile.Type.FOUR
		1:
			return Tile.Type.HALL
		2:
			return Tile.Type.T
		3:
			return Tile.Type.LEFT
		4:
			return Tile.Type.RIGHT
		_:
			return Tile.Type.END
	
	return Tile.Type.HALL



func tileExists(pos : Vector3) -> bool:
	return tileExistsRec(pos, startTile)


func tileExistsRec(pos : Vector3, searchTile : Tile) -> bool:
	if searchTile.position.is_equal_approx(pos):
		return true
	
	for t in searchTile.tiles:
		if tileExistsRec(pos, t):
			return true
	
	return false
