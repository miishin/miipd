extends Node2D
class_name GameWindow

var board

var cursor_pos = Vector2(0, 0)
var unit_pos = Vector2(0, 0)
var bee_pos = Vector2(6, 6)
var action : bool
var signal_callback : String

signal move
signal fight

# Initialize window with a board and the player's units
func init(b: Board, playerunits):
	board = b
	add_child(board)
	for player in playerunits:
		add_child(player)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	$Hamster.position = Vector2(0, 150)
	$Bee.position = convert_coordinate(Vector2(6, 6))	

	
func _input(event):
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
		hightlight_tiles(find_accessible_tiles(tiles[cursor_pos.x][cursor_pos.y], $Hamster.mov))
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
	tiles[cursor_pos.x][cursor_pos.y].deselect()
	cursor_pos.x = (int(cursor_pos.x) + dx + 7) % 7
	cursor_pos.y = (int(cursor_pos.y) + dy + 7) % 7
	place_cursor()

func place_cursor(show = false):
	var tile_position = board.convert_coordinate(Vector2(cursor_pos.x, cursor_pos.y))
	$Cursor.position = Vector2(tile_position[0], tile_position[1])
	$Cursor.position.y -= 50
	$Cursor.position.x -= 10
	tiles[cursor_pos.x][cursor_pos.y].select()
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
	if not tiles[cursor_pos.x][cursor_pos.y].is_highlighted():
		return
	var tile_path = _pathfinder(tiles[unit_pos.x][unit_pos.y], tiles[cursor_pos.x][cursor_pos.y], $Hamster.mov)
	tile_path = tile_path.slice(1, len(tile_path) - 1)
	unhighlight_tiles(find_accessible_tiles(tiles[unit_pos.x][unit_pos.y], $Hamster.mov))
	$Hamster.move_path(tile_coordinates(tile_path))
	unit_pos = cursor_pos
	action = false

func _on_fight_button_down():
	action = true
	signal_callback = "fight"
	$Menu.hide()

func fight():
	if cursor_pos == bee_pos:
		$Hamster.fight($Bee)
		action = false
