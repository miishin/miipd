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

func highlight_range(origin : Tile, ability : Ability):
	highlight_tiles(get_range(origin, ability))

func unhighlight_range(origin : Tile, ability : Ability):
	unhighlight_tiles(get_range(origin, ability))

func get_range(origin : Tile, ability : Ability) -> Array:
	var range_tiles = []
	match ability.range_angle:
		Ability.RangeAngle.FULL:
			return find_accessible(origin, int(ability.ability_range.x), int(ability.ability_range.y), true)
		Ability.RangeAngle.PERPENDICULAR:
			for i in range(ability.ability_range.x, ability.ability_range.y):
				var a = origin.pos + Vector2(i, 0)
				var b = origin.pos + Vector2(-i, 0)
				var c = origin.pos + Vector2(0, i)
				var d = origin.pos + Vector2(0, -i)
				if a.x >= 0 and a.x < num_rows:
					range_tiles.append(get_tile(a))
				if b.x >= 0 and b.x < num_rows:
					range_tiles.append(get_tile(b))
				if c.y >= 0 and c.y < num_cols:
					range_tiles.append(get_tile(c))
				if d.y >= 0 and d.y < num_cols:
					range_tiles.append(get_tile(d))
		Ability.RangeAngle.DIAGONAL:
			for i in range(ability.ability_range.x, ability.ability_range.y):
				var a = origin.pos + Vector2(i, i)
				var b = origin.pos + Vector2(-i, i)
				var c = origin.pos + Vector2(i, -i)
				var d = origin.pos + Vector2(-i, -i)
				if a.x >= 0 and a.x < num_rows:
					range_tiles.append(get_tile(a))
				if b.x >= 0 and b.x < num_rows:
					range_tiles.append(get_tile(b))
				if c.y >= 0 and c.y < num_cols:
					range_tiles.append(get_tile(c))
				if d.y >= 0 and d.y < num_cols:
					range_tiles.append(get_tile(d))
	return range_tiles

func get_aoe(unit : Unit, origin : Tile, ability : Ability) -> Array:
	var aoe_tiles = []
	match ability.aoe_type:
		Ability.AoeType.CIRCULAR:
			return find_accessible(origin, 0, ability.aoe)
		Ability.AoeType.LINE:
			if ability.aoe == 0:
				var diff : Vector2 = origin.pos - unit.occupied_tile 
				if diff.x != 0 and diff.y != 0:
					return aoe_tiles
				aoe_tiles = pathfinder(origin, get_tile(unit.occupied_tile), int(diff.abs().dot(Vector2(1,1))))
				aoe_tiles.pop_back()
			elif ability.aoe < 0:
				var diff : Vector2 = origin.pos - unit.occupied_tile
				diff = diff.normalized()
				diff = diff.round()
				for i in range(0, abs(ability.aoe)):
					var next_tile : Vector2 = origin.pos + i * diff
					if next_tile.x < 0 or next_tile.y < 0 or \
					next_tile.x >= num_rows or next_tile.y >= num_cols:
						continue
					aoe_tiles.append(get_tile(next_tile))
	return aoe_tiles

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

func get_enemy(coordinates : Vector2) -> Unit:
	for enemy in enemy_units:
		if enemy.occupied_tile == coordinates:
			return enemy
	return null
	
func get_tile(pos: Vector2) -> Tile:
	return tiles[pos.x][pos.y]
