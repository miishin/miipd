extends Board

var tile_file = preload("res://assets/scenes/tile.tscn")
var cursor_pos = Vector2(0, 0)
var unit_pos = Vector2(0, 0)
var bee_pos = Vector2(6, 6)
var action : bool
var signal_callback : String

signal move
signal fight

# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	var tile
	var tile_position
	for row in range(7):
		var row_tiles = []
		for col in range(7):
			tile = tile_file.instance()
			tile.place(row, col)
			tile_position = convert_coordinate(row, col)
			tile.position = Vector2(tile_position[0], tile_position[1])
			row_tiles.append(tile)
			add_child(tile)
		tiles.append(row_tiles)
	tile_position = convert_coordinate(0, 0)
	$Hamster.position = Vector2(tile_position[0], tile_position[1])
	tile_position = convert_coordinate(6, 6)
	$Bee.position = Vector2(tile_position[0], tile_position[1])
	
# Returns all the positions that are a given distance from a given (x, y) on the Board
func pathfind(pos, distance):
	return _pathfind_helper(pos, distance, [])
	
func _pathfind_helper(pos, distance, reachable_so_far):
	if distance == 0:
		return [pos]
	var neighbors = _get_neighbors(pos)
	for tile in neighbors:
		if not tile in reachable_so_far:
			reachable_so_far += _pathfind_helper(tile.pos, distance - 1, reachable_so_far)
	return reachable_so_far 
	
# Returns the 4 neighbors (or less if edge tile) of the given (x, y)
func _get_neighbors(pos):
	var neighbors = []
	var x = pos.x
	var y = pos.y
	if x == 0:
		neighbors.append(Vector2(x + 1, y))
	elif x == len(tiles) - 1:
		neighbors.append(Vector2(x - 1, y))
	else:
		neighbors.append(Vector2(x + 1, y))
		neighbors.append(Vector2(x - 1, y))
	if y == 0:
		neighbors.append(Vector2(x, y + 1))
	elif y == len(tiles[0]) - 1:
		neighbors.append(Vector2(x, y - 1))
	else:
		neighbors.append(Vector2(x, y + 1))
		neighbors.append(Vector2(x, y - 1))
	return neighbors
	
func _input(event):
	if $Menu.is_visible():
		return
	if action and event.is_action_pressed("ui_accept"):
		emit_signal(signal_callback)
		action = false
		return
	if event.is_action_pressed("ui_select") and cursor_pos == unit_pos:
		$Menu.buttons[0].grab_focus()
		$Menu.current_selection = 0
		$Menu._move_cursor()
		$Menu.show()
		return
	if event.is_action_pressed("ui_cancel"):
		$Menu.hide()
		return
	
	var dx = 0
	var dy = 0
	if Input.is_action_just_pressed("ui_right"):
		dx += 1
	if Input.is_action_just_pressed("ui_left"):
		dx -= 1
	if Input.is_action_just_pressed("ui_up"):
		dy -= 1
	if Input.is_action_just_pressed("ui_down"):
		dy += 1
	
	if (dx != 0 or dy != 0) and not $Cursor.is_visible():
		place_cursor(true)
		return
	cursor_pos.x = (int(cursor_pos.x) + dx + 7) % 7
	cursor_pos.y = (int(cursor_pos.y) + dy + 7) % 7
	place_cursor()


func place_cursor(show = false):
	var tile_position = convert_coordinate(cursor_pos.x, cursor_pos.y)
	$Cursor.position = Vector2(tile_position[0], tile_position[1])
	$Cursor.position.y -= 50
	$Cursor.position.x -= 10
	if show:
		$Cursor.show()
	update_hud()

func update_hud():
	var unit : Unit
	if cursor_pos == bee_pos:
		unit = $Bee
	if cursor_pos == unit_pos:
		unit = $Hamster
	if not unit:
		$HUD.hide()
		return
		
	$HUD/Stats/ATKVal.text = str(unit.atk)
	$HUD/Stats/HPVal.text = str(unit.hp)
	$HUD/Stats/DEFVal.text = str(unit.def)
	$HUD.show()

func _on_move_button_down():
	action = true
	signal_callback = "move"
	$Menu.hide()

func move():
	var tile_position = convert_coordinate(cursor_pos.x, cursor_pos.y)
	$Hamster.move(tile_position[0], tile_position[1])
	unit_pos = cursor_pos

func _on_fight_button_down():
	action = true
	signal_callback = "fight"
	$Menu.hide()

func fight():
	if cursor_pos == bee_pos:
		$Hamster.fight($Bee)
