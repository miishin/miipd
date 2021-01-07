extends Node2D
class_name GameWindow

const hamster = preload("res://assets/scenes/units/hamster.tscn")

var board : Board

var next            : bool
var action          : bool
var player_turn     : bool
var stage_number    : int
var all_units       : Array
var turn_queue      : Array
var player_units    : Array
var signal_callback : String
var current_unit    : Unit

var cursor_pos = Vector2(0, 0)

signal move
signal fight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init([hamster.instance(), hamster.instance()])

func set_coordinates(b : Board, units : Array) -> void:
	var i = 0
	for p in units:
		var t = Vector2(i, 0)
		p.position = b.convert_coordinate(t)
		p.occupied_tile = t
		i += 1

func init_units() -> void:
	all_units = []
	turn_queue = []
	for unit in player_units:
		all_units.append(unit)
		turn_queue.append(unit)
	for unit in board.enemy_units:
		all_units.append(unit)
		turn_queue.append(unit)
	turn_queue.sort_custom(self, "spd_comparator")
	for unit in turn_queue:
		$TurnQueue.add_unit(unit.clone())

func spd_comparator(unit1 : Unit, unit2 : Unit) -> int:
	return unit1.spd > unit2.spd

# Initialize window with a board and the player's units
func init(units: Array) -> void:
	stage_number = 0
	board = Board.new(7, 7)
	player_units = units
	
	set_coordinates(board, units)
	add_child(board)
	
	for unit in units:
		add_child(unit)
	init_units()
	current_unit = turn_queue[0]
	if current_unit in player_units:
		player_turn = true
	else:
		ai_turn()
	
func _input(event: InputEvent) -> void:
	if !player_turn:
		return
	if $Menu.is_visible():
		return
	if action and event.is_action_pressed("ui_accept"):
		perform_action()
		return
	if event.is_action_pressed("ui_select") and cursor_pos == current_unit.occupied_tile:
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
	
	move_cursor()
	place_cursor()

func perform_action() -> void:
	emit_signal(signal_callback)
	$Cursor.visible = false
	if next:
		player_turn = false
		next = false
		board.get_tile(cursor_pos).deselect()
		update_turn_queue()
	
func update_turn_queue() -> void:
	var last_unit = turn_queue.pop_front()
	turn_queue.push_back(last_unit)
	current_unit = turn_queue[0]
	
	last_unit = $TurnQueue.units.pop_front()
	$TurnQueue.units.push_back(last_unit)
	$TurnQueue.update()
	
	if not (current_unit in player_units):
		ai_turn()
	player_turn = true

func ai_turn() -> void:
	var closest_player = closest_unit(current_unit.occupied_tile, player_units)
	var diff = current_unit.occupied_tile - closest_player.occupied_tile
	diff = abs(diff.x) + abs(diff.y)
	
	var path = board.pathfinder(board.get_tile(current_unit.occupied_tile), board.get_tile(closest_player.occupied_tile), diff)
	path = path.slice(1, len(path) - 2) # Ignore last tile so that AI doesn't stand on top of player
	
	if len(path) == 0:
		current_unit.fight(closest_player)
	else:
		var accessible_path = path.slice(0, current_unit.mov)
		var yielded = current_unit.move_path(board.tile_coordinates(accessible_path))
		if yielded:
			Globals.yielded_animations.push_back(yielded)
		if accessible_path == path:
			current_unit.fight(closest_player)
		current_unit.occupied_tile = accessible_path[-1].pos
	update_turn_queue()
	
func closest_unit(origin : Vector2, units : Array) -> Unit:
	var closest = units[0]
	var diff_vector = origin - units[0].occupied_tile
	var min_distance = abs(diff_vector.x) + abs(diff_vector.y)
	for unit in units:
		diff_vector = origin - unit.occupied_tile
		var diff = abs(diff_vector.x) + abs(diff_vector.y)
		if diff < min_distance:
			min_distance = diff
			closest = unit
	return closest

func move_cursor() -> void:
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
	board.get_tile(cursor_pos).deselect()
	cursor_pos.x = (int(cursor_pos.x) + dx + 7) % 7
	cursor_pos.y = (int(cursor_pos.y) + dy + 7) % 7

func place_cursor(show = false) -> void:
	$Cursor.position = board.convert_coordinate(cursor_pos)
	$Cursor.position.y -= 50
	$Cursor.position.x -= 10
	board.get_tile(cursor_pos).select()
	if show:
		$Cursor.show()
	update_hud()

func update_hud() -> void:
	var unit : Unit
	for u in all_units:
		if u.occupied_tile == cursor_pos:
			unit = u
	if not unit:
		$HUD.hide()
		return
		
	$HUD/Stats/ATKVal.text = str(unit.atk)
	$HUD/Stats/HPVal.text = str(unit.hp)
	$HUD/Stats/DEFVal.text = str(unit.def)
	$HUD/Stats/SPDVal.text = str(unit.spd)
	$HUD.show()

func _on_move_button_down() -> void:
	action = true
	signal_callback = "move"
	$Menu.hide()

func move() -> void:
	if not board.get_tile(cursor_pos).is_highlighted():
		return
	var unit_tile = board.get_tile(current_unit.occupied_tile)
	var tile_path = board.pathfinder(unit_tile, board.get_tile(cursor_pos), current_unit.mov)
	tile_path.pop_front()
	board.unhighlight_tiles(board.find_accessible_tiles(unit_tile, current_unit.mov))
	var yielded = current_unit.move_path(board.tile_coordinates(tile_path))
	if yielded:
		Globals.yielded_animations.push_back(yielded)
	current_unit.occupied_tile = cursor_pos
	action = false
	next = true

func _on_fight_button_down() -> void:
	action = true
	signal_callback = "fight"
	$Menu.hide()

func fight() -> void:
	var enemy = board.get_enemy(cursor_pos)
	if enemy:
		var unit_tile = board.get_tile(current_unit.occupied_tile)
		current_unit.fight(enemy)
		action = false
		board.unhighlight_tiles(board.find_accessible_tiles(unit_tile, current_unit.mov))
		next = true
