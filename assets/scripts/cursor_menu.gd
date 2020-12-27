extends Control

var buttons = []
var current_selection = 0

func _ready():
	for child in $VBoxContainer.get_children():
		buttons.append(child)
	for child in get_children():
		if child is Button:
			remove_child(child)
			add_button(child)
	buttons[0].focus_neighbour_top = buttons[-1].get_path()
	buttons[-1].focus_neighbour_bottom = buttons[0].get_path()
	buttons[0].grab_focus()
	
	
func _input(event):
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
		var dir = int(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
		current_selection = (current_selection + dir + len(buttons)) % len(buttons)
		_move_cursor()
	

func _move_cursor():
	if len(buttons) == 0:
		return
	
	var current_button = buttons[current_selection]
	$Cursor.position.y = $VBoxContainer.rect_position.y + current_button.rect_position.y \
		+ current_button.rect_size.y / 2

func add_button(button):
	$VBoxContainer.add_child(button)
	
	if len(buttons) >= 1:
		var prev_button = buttons[-1]
		prev_button.focus_neighbour_bottom = button.get_path()
		button.focus_neighbour_top = prev_button.get_path()
		
	buttons.append(button)
