extends Popup

var option_texture = preload('res://assets/graphics/backgrounds/menu_option.png')
var selected_option_texture = preload('res://assets/graphics/backgrounds/menu_option_selected.png')

var selection : int
var paused    : bool
# 0 - resume
# 1 - options
# 2 - quit

func _ready():
	selection = 0
	set_selection_color()
	rect_position = Vector2(500, 210)
	popup()
	visible = false
	paused = false

func reset_colors():
	$Resume.texture = option_texture
	$MainMenu.texture = option_texture
	$Quit.texture = option_texture

func set_selection_color():
	match selection:
		0:
			$Resume.texture = selected_option_texture
		1:
			$MainMenu.texture = selected_option_texture
		2:
			$Quit.texture = selected_option_texture

func pause():
	paused = !paused
	visible = !visible

func _input(event : InputEvent):
	if !paused:
		return
	if event.is_action_pressed('ui_down'):
		selection = (selection + 1) % 3
	elif event.is_action_pressed('ui_up'):
		selection = (selection + 2) % 3
	elif event.is_action_pressed('ui_select'):
		match selection:
			0:
				pause()
			1: 
				get_tree().change_scene("res://assets/scenes/main_menu.tscn")
			2:
				get_tree().quit()
	reset_colors()
	set_selection_color()
