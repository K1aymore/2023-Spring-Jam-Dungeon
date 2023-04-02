extends Node3D


const OFFSET = Vector2(0, -4)

const TILE_NUM = 10
var counter := 0
var openEnds := 0

var startTile := Tile.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	startTile.setType(Tile.Type.START)
	add_child(startTile)
	openEnds += 1
	
	generateMap(startTile)



func generateMap(tile : Tile):
	counter += 1
	for i in tile.maxTiles:
		var newTile = randTile()
		
		tile.connectTile(newTile)
		
		add_child(newTile)
		openEnds += newTile.maxTiles - 1
		
		generateMap(newTile)


func randTile() -> Tile:
	var newTile := Tile.new()
	var rand : int
	
	if openEnds <= 1:
		rand = randi_range(0, 4)
	else:
		rand = randi_range(0, 5)
	
	if counter >= TILE_NUM:
		rand = 5
	
	match rand:
		0:
			newTile.setType(Tile.Type.FOUR)
		1:
			newTile.setType(Tile.Type.HALL)
		2:
			newTile.setType(Tile.Type.T)
		3:
			newTile.setType(Tile.Type.LEFT)
		4:
			newTile.setType(Tile.Type.RIGHT)
		5:
			newTile.setType(Tile.Type.END)
	
	return newTile



#func generateTile():
#	if tileExists(currentPos):
#		currentPos += OFFSET
#		addTile(currentPos, 0)
#	else:
#		addTile(currentPos, 0)
#



#func addTile(pos : Vector2, rot : float):
#	pos = pos.snapped(Vector2(4, 4))
#	rot = snapped(rot, PI/2)
#
#	var tile = randTile()
#	tile.position = Vector3(pos.x, 0, pos.y)
#	tile.rotation.y = rot
#
#	add_child(tile)
#	map[pos] = tile
#
#func randTile() -> StaticBody3D:
#	var rand = randi_range(0, tiles.size()-1)
#
#	if rand >= tiles.size():
#		rand = 0
#
#	return tiles[rand].instantiate()


func tileExists(pos : Vector3, searchTile : Tile) -> bool:
	if searchTile.position.is_equal_approx(pos):
		return true
	
	for t in searchTile.tiles:
		if tileExists(pos, t):
			return true
	
	return false
