extends StaticBody3D

class_name Tile

var wallScene = preload("res://Scenes/wall.tscn")

var tiles : Array[Tile]
var tileOffsets : Array[Vector3i]
var tileRotations : Array[float]
var maxTiles := 0

enum Type {
	END,
	HALL,
	T,
	LEFT,
	RIGHT,
	FOUR,
	START
}

var type : Type

var front = Vector3i(2, 0, 0)
var left = Vector3i(0, 0, -2)
var right = Vector3i(0, 0, 2)
var back = Vector3i(-2, 0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func setType(toset : Type):
	type = toset
	
	match type:
		Type.END:
			addWall(front)
			addWall(left)
			addWall(right)
			maxTiles = 0
			tileOffsets = []
			tileRotations = []
		Type.HALL:
			addWall(left)
			addWall(right)
			maxTiles = 1
			tileOffsets = [ Vector3i(front*2) ]
			tileRotations = [ 0 ]
		Type.T:
			addWall(front)
			maxTiles = 2
			tileOffsets = [ Vector3i(left*2), Vector3i(right*2) ]
			tileRotations = [ PI/2, (3*PI)/2 ]
		Type.LEFT:
			addWall(front)
			addWall(right)
			maxTiles = 1
			tileOffsets = [ Vector3i(left*2) ]
			tileRotations = [ PI/2, (3*PI)/2 ]
		Type.RIGHT:
			addWall(front)
			addWall(left)
			maxTiles = 1
			tileOffsets = [ Vector3i(right*2) ]
			tileRotations = [ (3*PI)/2 ]
		Type.FOUR:
			maxTiles = 3
			tileOffsets = [ Vector3i(left*2), Vector3i(front*2), Vector3i(right*2) ]
			tileRotations = [ PI/2, 0, (3*PI)/2 ]
		Type.START:
			addWall(back)
			addWall(left)
			addWall(right)
			maxTiles = 1
			tileOffsets = [ Vector3i(front*2) ]
			tileRotations = [ 0 ]



func addWall(pos : Vector3i):
	var wall = wallScene.instantiate()
	pos.y += 2
	wall.position = pos
	
	if pos.z == 0:
		wall.rotation.y = PI/2
	
	add_child(wall)



func connectTile(tile : Tile):
	var index := tiles.size()
	
	tiles.append(tile)
	
	var tileOffset = Vector3(tileOffsets[index]).rotated(Vector3.UP, self.rotation.y)
	
	tile.position = self.position + tileOffset
	tile.rotation.y = self.rotation.y + tileRotations[index]
