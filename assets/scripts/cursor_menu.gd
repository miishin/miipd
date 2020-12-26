extends Control

var b = Button
var buttons = []
var current_selection = 0

func _ready():
	for child in get_children():
		if child is Button:
			remove_child(child)
			add_button(child)
	_move_cursor()
	
func _input(event):
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
		var dir = int(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
		current_selection = (current_selection + dir) % len(buttons)
		_move_cursor()

func _move_cursor():
	if len(buttons) == 0:
		return
	
	var focus_owner = get_focus_owner()
	if focus_owner != null:
		focus_owner.release_focus()
	var current_button = buttons[current_selection]
	current_button.grab_focus()
	$Cursor.position.y = current_button.rect_position.y + current_button.rect_size.y / 2

func add_button(button):
	$VBoxContainer.add_child(button)
	buttons.append(button)
