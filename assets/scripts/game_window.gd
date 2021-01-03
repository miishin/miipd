extends Node2D
class_name GameWindow

var board : Board

var cursor_pos = Vector2(0, 0)
var unit_pos = Vector2(0, 0)
var action : bool
var signal_callback : String
var current_unit : Unit

signal move
signal fight

# Initialize window with a board and the player's units
func init(b: Board, playerunits: Array) -> void:
	board = b
	add_child(board)
	current_unit = playerunits[0]
	for player in playerunits:
		add_child(player)
	
func _input(event: InputEvent) -> void:
	if $Menu.is_visible():
		return
	if action and event.is_action_pressed("ui_accept"):
		emit_signal(signal_callback)
		return
	if event.is_action_pressed("ui_select") and cursor_pos == unit_pos:
		$Menu.buttons[0].grab_focus()
		$Menu.current_selection = 0
		$Menu._move_cursor()
		$Menu.show()
		board.hightlight_tiles(board.find_accessible_tiles(
			board.tiles[cursor_pos.x][cursor_pos.y], current_unit.mov))
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
	board.tiles[cursor_pos.x][cursor_pos.y].deselect()
	cursor_pos.x = (int(cursor_pos.x) + dx + 7) % 7
	cursor_pos.y = (int(cursor_pos.y) + dy + 7) % 7
	place_cursor()

func place_cursor(show = false) -> void:
	var tile_position = board.convert_coordinate(Vector2(cursor_pos.x, cursor_pos.y))
	$Cursor.position = Vector2(tile_position[0], tile_position[1])
	$Cursor.position.y -= 50
	$Cursor.position.x -= 10
	board.tiles[cursor_pos.x][cursor_pos.y].select()
	if show:
		$Cursor.show()
	update_hud()

func update_hud() -> void:
	var unit : Unit
	unit = board.get_enemy(cursor_pos)
	if cursor_pos == unit_pos:
		unit = current_unit
	if not unit:
		$HUD.hide()
		return
		
	$HUD/Stats/ATKVal.text = str(unit.atk)
	$HUD/Stats/HPVal.text = str(unit.hp)
	$HUD/Stats/DEFVal.text = str(unit.def)
	$HUD.show()

func _on_move_button_down() -> void:
	action = true
	signal_callback = "move"
	$Menu.hide()

func move() -> void:
	if not board.tiles[cursor_pos.x][cursor_pos.y].is_highlighted():
		return
	var tile_path = board._pathfinder(board.tiles[unit_pos.x][unit_pos.y],
		board.tiles[cursor_pos.x][cursor_pos.y], current_unit.mov)
	tile_path = tile_path.slice(1, len(tile_path) - 1)
	board.unhighlight_tiles(board.find_accessible_tiles(board.tiles[unit_pos.x][unit_pos.y], current_unit.mov))
	current_unit.move_path(board.tile_coordinates(tile_path))
	unit_pos = cursor_pos
	action = false

func _on_fight_button_down() -> void:
	action = true
	signal_callback = "fight"
	$Menu.hide()

func fight() -> void:
	var enemy = board.get_enemy(cursor_pos)
	if enemy:
		current_unit.fight(enemy)
		action = false
