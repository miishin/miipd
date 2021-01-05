extends 'res://addons/gut/test.gd'

var _board = null

func before_all():
	_board = Board.new(7, 7)

func test_initialize_tiles():
	assert_eq(len(_board.tiles), 7)
	for i in range(7):
		assert_eq(len(_board.tiles[i]), 7)

func test_neighbors():
	var neighbors = _board.tiles[0][0].get_neighbors()
	var result = false
	result = neighbors.has(_board.tiles[1][0])
	result = neighbors.has(_board.tiles[0][1])
	assert_true(result)

# Neighbors	
func test_find_accessible_tiles_dist1():
	var neighbors = _board.tiles[3][3].get_neighbors()
	var accessible = _board.find_accessible_tiles(_board.tiles[3][3], 1)
	var result
	for tile in neighbors:
		result = accessible.has(tile)
	assert_true(result)
	
func test_find_accessible_tiles_dist2():
	var accessible = _board.find_accessible_tiles(_board.tiles[3][3], 2)
	var tile = _board.tiles[3][3]
	var reachable_tiles = tile.get_neighbors()
	reachable_tiles.append(_board.tiles[3][1])
	reachable_tiles.append(_board.tiles[3][5])
	reachable_tiles.append(_board.tiles[1][3])
	reachable_tiles.append(_board.tiles[2][2])
	reachable_tiles.append(_board.tiles[2][4])
	reachable_tiles.append(_board.tiles[4][2])
	reachable_tiles.append(_board.tiles[4][4])
	reachable_tiles.append(_board.tiles[5][3])
	var result = false
	for reachable_tile in reachable_tiles:
		result = accessible.has(reachable_tile)
	assert_true(result)

func test_pathfinder():
	var path = [_board.tiles[0][0], _board.tiles[1][0], _board.tiles[2][0], _board.tiles[3][0], _board.tiles[4][0]]
	var found_path = _board._pathfinder(_board.tiles[0][0], _board.tiles[4][0], 4)
	var result = false
	for tile in path:
		result = found_path.has(tile)
	assert_true(result)

func test_pathfinder_with_obstacle():
	_board.tiles[1][0].passable = false
	var path = [_board.tiles[0][0], _board.tiles[0][1], _board.tiles[1][1], _board.tiles[2][1], _board.tiles[2][0]]
	assert_eq(_board._pathfinder(_board.tiles[0][0], _board.tiles[2][0], 4), path)
	
