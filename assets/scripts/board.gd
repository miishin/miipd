extends Node2D
class_name Board

var tile_file = preload("res://assets/scenes/tile.tscn")
var units # for showing turn order
var tiles = []
# Offset so Board isn't stuck to top of screen
const OFFSET = 150

# Size of the board
var num_rows = 7
var num_cols = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	pass #

# Instantiate board tiles
func _init():
	var tile
	for row in range(num_rows):
		var row_tiles = []
		for col in range(num_cols):
			tile = tile_file.instance()
			tile.place(Vector2(row, col))
			tile.position = convert_coordinate(Vector2(row, col))
			row_tiles.append(tile)
			add_child(tile)
			if row > 0:
				var neighbor = tiles[row - 1][col]
				tile.set_top_neighbor(neighbor)
				neighbor.set_bottom_neighbor(tile)
			if col > 0:
				var neighbor = row_tiles[col - 1]
				tile.set_left_neighbor(neighbor)
				neighbor.set_right_neighbor(tile)
		tiles.append(row_tiles)

func get_neighbors(pos):
	var tile = tiles[pos.x][pos.y]
	return tile.get_neighbors()

# Returns a list of all tiles accessible from the given tile within 
# a given Manhattan distance
func find_accessible_tiles(tile, distance):
	return _pathfinder(tile, distance, [])

func _pathfinder(tile, distance, seen):
	if distance == 0:
		return tile
	var neighbors = tile.get_neighbors()
	for neighbor in neighbors:
		if not neighbor in seen:
			seen += _pathfinder(neighbor, distance - 1, seen)
	return seen
	
# Converts from the coordinate on the board to the coordinate
# on the screen. 
# One tile in the x direction = +62.5x, +31y
# One tile in the y direction = -62.5x, +31y
func convert_coordinate(pos):
	var new_x
	var new_y
	new_x = 62.5 * pos.x - 62.5 * pos.y
	new_y = 31 * (pos.x + pos.y) + OFFSET
	return Vector2(new_x, new_y)

func in_range(tile_origin, tile_dest, dist):
	# check if tile is within range <= dist
	pass
