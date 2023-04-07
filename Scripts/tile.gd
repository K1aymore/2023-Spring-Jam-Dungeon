extends StaticBody3D

class_name Tile

var wallScene = preload("res://Scenes/wall.tscn")

var tiles : Array[Tile]
var tileOffsets : Array[Vector3i]
var tileRotations : Array[float]
var maxTiles := 0

var isCombatTile := false

enum Type {
	END,
	HALL,
	T,
	LEFT,
	RIGHT,
	FOUR,
	START,
	EMPTY
}

var type : Type

var front = Vector3i(2, 0, 0)
var left = Vector3i(0, 0, -2)
var right = Vector3i(0, 0, 2)
var back = Vector3i(-2, 0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	buildWalls()
	if type != Type.START:
		var rand := randi_range(0, 5)
		isCombatTile = rand == 0


func buildWalls():
	match type:
		Type.END:
			addWall(front)
			addWall(left)
			addWall(right)
		Type.HALL:
			addWall(left)
			addWall(right)
		Type.T:
			addWall(front)
		Type.LEFT:
			addWall(front)
			addWall(right)
		Type.RIGHT:
			addWall(front)
			addWall(left)
		Type.FOUR:
			pass
		Type.START:
			addWall(back)
			addWall(left)
			addWall(right)
		Type.EMPTY:
			pass




func setType(toset : Type):
	type = toset
	
	match type:
		Type.END:
			maxTiles = 0
			tileOffsets = []
			tileRotations = []
		Type.HALL:
			maxTiles = 1
			tileOffsets = [ Vector3i(front*2) ]
			tileRotations = [ 0 ]
		Type.T:
			maxTiles = 2
			tileOffsets = [ Vector3i(left*2), Vector3i(right*2) ]
			tileRotations = [ PI/2, (3*PI)/2 ]
		Type.LEFT:
			maxTiles = 1
			tileOffsets = [ Vector3i(left*2) ]
			tileRotations = [ PI/2, (3*PI)/2 ]
		Type.RIGHT:
			maxTiles = 1
			tileOffsets = [ Vector3i(right*2) ]
			tileRotations = [ (3*PI)/2 ]
		Type.FOUR:
			maxTiles = 3
			tileOffsets = [ Vector3i(left*2), Vector3i(front*2), Vector3i(right*2) ]
			tileRotations = [ PI/2, 0, (3*PI)/2 ]
		Type.START:
			maxTiles = 1
			tileOffsets = [ Vector3i(front*2) ]
			tileRotations = [ 0 ]
		Type.EMPTY:
			maxTiles = 0
			tileOffsets = []
			tileRotations = []



func addWall(pos : Vector3i):
	var wall = wallScene.instantiate()
	pos.y += 2
	wall.position = pos
	
	if pos.z == 0:
		wall.rotation.y = PI/2
	
	add_child(wall)



func connectTile(tile : Tile):
	var index := tiles.size()
	var tileOffset = Vector3(tileOffsets[index]).rotated(Vector3.UP, self.rotation.y)
	
	tiles.append(tile)
	
	tile.position = self.position + tileOffset
	tile.rotation.y = self.rotation.y + tileRotations[index]


func nextPos() -> Vector3:
	var index := tiles.size()
	var tileOffset = Vector3(tileOffsets[index]).rotated(Vector3.UP, self.rotation.y)
	
	return self.position + tileOffset


func nextRot() -> float:
	var index := tiles.size()
	
	return self.rotation.y + tileRotations[index]


