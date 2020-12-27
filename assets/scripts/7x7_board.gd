extends "res://assets/scripts/board.gd"

var tile_file = preload("res://assets/scenes/tile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	var tile
	var tile_position
	for row in range(7):
		for col in range(7):
			tile = tile_file.instance()
			tile_position = convert_coordinate(row, col)
			tile.position = Vector2(tile_position[0], tile_position[1])
			tiles.append(tile)
			add_child(tile) 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
