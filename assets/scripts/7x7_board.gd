extends Board

var tile_file = preload("res://assets/scenes/tile.tscn")
var cursor_pos = Vector2(0, 0)
var unit_pos = Vector2(0, 0)
var moving : bool

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
	tile_position = convert_coordinate(0, 0)
	$Hamster.position = Vector2(tile_position[0], tile_position[1])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if $Menu.is_visible():
		return
	if moving and event.is_action_pressed("ui_accept"):
		var tile_position = convert_coordinate(cursor_pos.x, cursor_pos.y)
		$Hamster.move(tile_position[0], tile_position[1])
		unit_pos = cursor_pos
		moving = false
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

func _on_move_button_down():
	moving = true
	$Menu.hide()
