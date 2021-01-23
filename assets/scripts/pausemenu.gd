extends Node2D

var option_texture = preload('res://assets/graphics/backgrounds/menu_option.png')
var selected_option_texture = preload('res://assets/graphics/backgrounds/menu_option_selected.png')
var selection : int
# 0 - resume
# 1 - options
# 2 - quit

func _ready():
	selection = 0
	set_selection_color()
	$menu.rect_position = Vector2(500, 210)
	$menu.popup()
	$menu.visible = false

func reset_colors():
	$menu/resume.texture = option_texture
	$menu/options.texture = option_texture
	$menu/quit.texture = option_texture

func set_selection_color():
	match selection:
		0:
			$menu/resume.texture = selected_option_texture
		1:
			$menu/options.texture = selected_option_texture
		2:
			$menu/quit.texture = selected_option_texture

func _input(event : InputEvent):
	if event.is_action_pressed('ui_down'):
		selection = (selection + 1) % 3
	elif event.is_action_pressed('ui_up'):
		selection = (selection - 1) % 3
	elif event.is_action_pressed('ui_select'):
		match selection:
			0:
				$menu.visible = false
			1: 
				print("open options")
			2:
				get_tree().quit()
	elif event.is_action_pressed('pause'):
		$menu.visible = !$menu.visible
		selection = 0
	reset_colors()
	set_selection_color()
