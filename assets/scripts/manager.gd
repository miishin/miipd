extends Node2D
class_name GameWindow

const hamster = preload("res://assets/scenes/units/hamster.tscn")
const MAX_ABILITIES = 3

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

var signal_args = []
var turn_state  = []
var cursor_pos  = Vector2(0, 0)

# warning-ignore:unused_signal
signal move
# warning-ignore:unused_signal
signal ability

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init(Globals.player_characters)

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

func spd_comparator(unit1 : Unit, unit2 : Unit) -> bool:
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
		load_ability_menu()
	else:
		ai_turn()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		$CanvasLayer/PauseMenu.pause()
	if $CanvasLayer/PauseMenu.paused:
		return
	if !player_turn:
		return
	if $CanvasLayer/Menu.is_visible():
		return
	if action and event.is_action_pressed("ui_accept"):
		perform_action()
		return
	if event.is_action_pressed("ui_select") and cursor_pos == current_unit.occupied_tile:
		$CanvasLayer/Menu.buttons[0].grab_focus()
		$CanvasLayer/Menu.current_selection = 0
		$CanvasLayer/Menu._move_cursor()
		$CanvasLayer/Menu.show()
		return
	if event.is_action_pressed("ui_cancel"):
		$CanvasLayer/Menu.hide()
		return
	move_cursor()
	place_cursor()

func perform_action() -> void:
	emit_signal(signal_callback, signal_args)
	$Cursor.visible = false
	if next:
		change_turn()

func is_stage_over():
	return len(board.enemy_units) == 0

func is_game_over():
	return len(player_units) == 0
	
func update_gamestate():
	if is_stage_over() or is_game_over():
		get_tree().change_scene("res://assets/scenes/game_over.tscn")
	update_turn_queue()
	
func update_turn_queue() -> void:
	var last_unit = turn_queue.pop_front()
	turn_queue.push_back(last_unit)
	current_unit = turn_queue[0]
	load_ability_menu()
	
	last_unit = $TurnQueue.units.pop_front()
	$TurnQueue.units.push_back(last_unit)
	$TurnQueue.update()
	
	if not (current_unit in player_units):
		ai_turn()
	player_turn = true

func load_ability_menu() -> void:
	var abilities = current_unit.abilities
	for i in range(MAX_ABILITIES):
		var ability_button = get_node("CanvasLayer/Menu/VBoxContainer/Ability" + str(i + 1))
		if i < len(abilities):
			$CanvasLayer/Menu.show_button(i + 1)
			ability_button.text = abilities[i].title
		else:
			$CanvasLayer/Menu.hide_button(i + 1)

func ai_turn() -> void:
	var closest_player = closest_unit(current_unit.occupied_tile, player_units)
	if not closest_player:
		return
	var diff = current_unit.occupied_tile - closest_player.occupied_tile
	diff = abs(diff.x) + abs(diff.y)
	
	var path = board.pathfinder(board.get_tile(current_unit.occupied_tile), board.get_tile(closest_player.occupied_tile), diff)
	path = path.slice(1, len(path) - 2) # Ignore last tile so that AI doesn't stand on top of player
	
	if len(path) == 0:
		current_unit.abilities[0].target_apply(current_unit, closest_player)
		if closest_player.dead():
			remove_unit(closest_player)
	else:
		var accessible_path = path.slice(0, current_unit.mov)
		var yielded = current_unit.move_path(board.tile_coordinates(accessible_path))
		if yielded:
			Globals.yielded_animations.push_back(yielded)
		if accessible_path == path:
			current_unit.abilities[0].target_apply(current_unit, closest_player)
			if closest_player.dead():
				remove_unit(closest_player)
		current_unit.occupied_tile = accessible_path[-1].pos
	current_unit.end_turn()
	update_gamestate()
	
func closest_unit(origin : Vector2, units : Array) -> Unit:
	if len(units) == 0:
		return null
	var closest = units[0]
	var diff_vector = origin - units[0].occupied_tile
	var min_distance = abs(diff_vector.x) + abs(diff_vector.y) - closest.aggro
	for unit in units:
		diff_vector = origin - unit.occupied_tile
		var diff = abs(diff_vector.x) + abs(diff_vector.y) - unit.aggro
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
	if signal_callback == "ability":
		highlight_ability_range(current_unit, signal_args[0])
		if board.get_tile(cursor_pos).is_highlighted():
			var ability : Ability = current_unit.abilities[signal_args[0]]
			var tiles = ability.get_aoe(current_unit, board.get_tile(cursor_pos), board)
			board.highlight_tiles(tiles, Tile.RED_HIGHLIGHT) 
	if show:
		$Cursor.show()
	update_hud()

func update_hud() -> void:
	var unit : Unit
	for u in all_units:
		if u.occupied_tile == cursor_pos:
			unit = u
	if not unit:
		$CanvasLayer/HUD.hide()
		return
		
	$CanvasLayer/HUD/Stats/ATKVal.text = str(unit.atk)
	$CanvasLayer/HUD/Stats/HPVal.text = str(unit.hp)
	$CanvasLayer/HUD/Stats/DEFVal.text = str(unit.def)
	$CanvasLayer/HUD/Stats/SPDVal.text = str(unit.spd)
	$CanvasLayer/HUD.show()

func _on_ability_down(num : int):
	action = true
	signal_callback = "ability"
	signal_args.clear()
	signal_args.append(num)
	highlight_ability_range(current_unit, num)
	$CanvasLayer/Menu.hide()

func highlight_ability_range(unit : Unit, i : int):
	board.unhighlight_all()
	unit.abilities[i].highlight_range(board.get_tile(unit.occupied_tile), board)

func _on_move_button_down() -> void:
	action = true
	signal_callback = "move"
	board.unhighlight_all()
	board.highlight_tiles(board.find_accessible_tiles(
		board.get_tile(cursor_pos), current_unit.mov))
	$CanvasLayer/Menu.hide()

func _on_end_turn_button_down():
	change_turn()
	$CanvasLayer/Menu.hide()

func change_turn():
	player_turn = false
	next = false
	signal_callback = ""
	current_unit.end_turn()
	signal_args = []
	turn_state.clear()
	board.get_tile(cursor_pos).deselect()
	$CanvasLayer/Menu/VBoxContainer/Move.disabled = false
	board.unhighlight_all()
	enable_abilities()
	update_gamestate()

func update_turn_state(action_str : String) -> void:
	signal_callback = ""
	signal_args = []
	turn_state.append(action_str)
	if len(turn_state) == 2:
		next = true

func move(_args : Array) -> void:
	if not board.get_tile(cursor_pos).is_highlighted() or signal_callback in turn_state:
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
	update_turn_state(signal_callback)
	$CanvasLayer/Menu/VBoxContainer/Move.disabled = true

func ability(args : Array) -> void:
	if signal_callback in turn_state:
		print("can't perform this action")
		return
	var ability : Ability = current_unit.abilities[args[0]]
	var cursor_tile : Tile = board.get_tile(cursor_pos)
	if not cursor_tile.is_highlighted():
		print("can't select this tile")
		return
		
	var targetable_units = []
	match ability.target:
		Ability.AbilityTarget.ALL_UNITS:
			targetable_units = all_units
		Ability.AbilityTarget.EMPTY:
			targetable_units = all_units
		Ability.AbilityTarget.ALLY:
			targetable_units = player_units
		Ability.AbilityTarget.ENEMY:
			targetable_units = board.enemy_units
		Ability.AbilityTarget.ALL:
			pass
	if len(targetable_units) > 0:
		var valid : bool = false
		for unit in targetable_units:
			if unit.occupied_tile == cursor_pos:
				valid = true
				break
		if ability.target == Ability.AbilityTarget.EMPTY:
			valid = !valid
		if not valid:
			print("invalid target")
			return
	var tiles = ability.get_aoe(current_unit, cursor_tile, board)
	
	var hit_units = []
	for tile in tiles:
		for unit in all_units:
			if unit.occupied_tile == tile.pos:
				hit_units.append(unit)
	for unit in hit_units:
		ability.target_apply(current_unit, unit)
		if unit.dead():
			remove_unit(unit)
	ability.self_apply(current_unit, hit_units, cursor_tile, board)
	action = false
	board.unhighlight_all()
	update_turn_state(signal_callback)
	disable_abilities()

func disable_abilities():
	for i in range(MAX_ABILITIES):
		get_node("CanvasLayer/Menu/VBoxContainer/Ability" + str(i + 1)).disabled = true

func enable_abilities():
	for i in range(MAX_ABILITIES):
		get_node("CanvasLayer/Menu/VBoxContainer/Ability" + str(i + 1)).disabled = false

func remove_unit(unit : Unit):
	if unit in board.enemy_units:
		board.enemy_units.erase(unit)
	elif unit in player_units:
		player_units.erase(unit)
	all_units.erase(unit)
	turn_queue.erase(unit)
	$TurnQueue.delete_unit(unit)
	unit.queue_free()
