extends Node2D
class_name Board

var tile_file = preload("res://assets/scenes/tile.tscn")
var bee = preload("res://assets/scenes/units/bee.tscn")
var enemy_units = []
var tiles = []
# Offset so Board isn't stuck to top of screen
const OFFSET = 150
# The horizontal distance from the center of the tile to the edge
const TILE_HALF_WIDTH = 62
# The vertical distance from the center of the tile to the top
const TILE_HALF_HEIGHT = 31

# Size of the board
var num_rows
var num_cols

func _init(r : int, c : int) -> void:
	initialize_tiles(r, c)
	var b = bee.instance()
	var b2 = bee.instance()
	enemy_units.append(b)
	enemy_units.append(b2)
	b.occupied_tile = Vector2(6, 6)
	b.position = convert_coordinate(b.occupied_tile)
	b2.occupied_tile = Vector2(0, 6)
	b2.position = convert_coordinate(b2.occupied_tile)
	add_child(b)
	add_child(b2)
	
# Instantiate board tiles
func initialize_tiles(r : int, c : int) -> void:
	num_rows = r
	num_cols = c
	var tile
	for row in range(num_rows):
		var row_tiles = []
		for col in range(num_cols):
			tile = tile_file.instance()
			tile.init_tile()
			tile.set_pos(Vector2(row, col))
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
	
func get_neighbors(pos : Vector2) -> Array:
	var tile = tiles[pos.x][pos.y]
	return tile.get_neighbors()

func find_accessible(tile : Tile, min_distance : int, max_distance : int, ignore_passable : bool = false) -> Array:
	var accessible_tiles = []
	for dx in range(-max_distance, max_distance + 1):
		var x = (dx + tile.pos.x)
		if x < 0 or x >= len(tiles):
			continue
		for dy in range(-max_distance, max_distance + 1):
			var dist = abs(dx) + abs(dy)
			if dist > max_distance or dist < min_distance:
				continue
			var y = (dy + tile.pos.y)
			if y < 0 or y >= len(tiles):
				continue
			if ignore_passable or (tiles[x][y].is_passable() and \
				 len(pathfinder(tiles[x][y], tile, max_distance)) > 0):
				accessible_tiles.append(tiles[x][y])
	return accessible_tiles

# Returns a list of all tiles accessible from the given tile within 
# a given Manhattan distance
func find_accessible_tiles(tile : Tile, distance : int) -> Array:
	return find_accessible(tile, 0, distance)

# Returns the list of tiles that make up a path from an origin tile to a goal tile.
func pathfinder(origin : Tile, destination : Tile, distance : int) -> Array:
	if distance < 0:
		return []
	if origin == destination:
		return [origin]
	for neighbor in origin.get_neighbors():
		if neighbor.is_passable():
			var neighbor_path = pathfinder(neighbor, destination, distance - 1)
			if len(neighbor_path) > 0:
				return [origin] + neighbor_path
	return []

# Highlights the given tiles
func highlight_tiles(tile_list : Array, color : Color = Tile.NORMAL_HIGHLIGHT) -> void:
	for tile in tile_list:
		tile.highlight(color)

# Un-highlights the given tiles
func unhighlight_tiles(tile_list : Array) -> void:
	for tile in tile_list:
		tile.unhighlight()

func unhighlight_all() -> void:
	for row in tiles:
		for tile in row:
			tile.unhighlight()

# Converts from the coordinate on the board to the coordinate
# on the screen. 
# One tile in the x direction = +62.5x, +31y
# One tile in the y direction = -62.5x, +31y
func convert_coordinate(pos : Vector2) -> Vector2:
	var new_x
	var new_y
	new_x = TILE_HALF_WIDTH * pos.x - TILE_HALF_WIDTH * pos.y
	new_y = TILE_HALF_HEIGHT * (pos.x + pos.y) + OFFSET
	return Vector2(new_x, new_y)

# Converts multiple coordinates
func tile_coordinates(tile_list : Array) -> Array:
	var coordinates = []
	for tile in tile_list:
		coordinates.append(convert_coordinate(tile.pos))
	return coordinates

func get_tile(pos: Vector2) -> Tile:
	return tiles[pos.x][pos.y]
