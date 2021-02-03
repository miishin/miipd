extends Control

var char1 = preload("res://assets/scenes/units/hamster.tscn")
var char2 = preload("res://assets/scenes/units/bee.tscn")
var char3 = preload("res://assets/scenes/units/crab.tscn")
var char4 = preload("res://assets/scenes/units/salamander.tscn")
var char5 = preload("res://assets/scenes/units/birb.tscn")
var char6 = preload("res://assets/scenes/units/turtle.tscn")

onready var num_selected = 0
onready var selected_characters = []
onready var selection_boxes = [
	$selected/s1,
	$selected/s2,
	$selected/s3
]

onready var selection_map = {
	"c1"  : false,
	"c2"  : false,
	"c3"  : false,
	"c4"  : false,
	"c5"  : false,
	"c6"  : false,
}


onready var cmap = {
	"c1" : char1,
	"c2" : char2,
	"c3" : char3,
	"c4" : char4,
	"c5" : char5,
	"c6" : char6,
}

onready var button_map = {
	"c1"  : $GridContainer/c1,
	"c2"  : $GridContainer/c2,
	"c3"  : $GridContainer/c3,
	"c4"  : $GridContainer/c4,
	"c5"  : $GridContainer/c5,
	"c6"  : $GridContainer/c6,
}

var all_buttons : Array
var button_grid : Array
var current_selection : Vector2

const ROW_SIZE = 3

func _ready():
	all_buttons = button_map.keys()
	button_grid = [all_buttons.slice(0, ROW_SIZE - 1), all_buttons.slice(ROW_SIZE, 2 * ROW_SIZE - 1), [$back, $forward]]
	for c in button_map:
		button_map[c].connect("pressed", self, "_some_button_pressed", [button_map[c]])
	current_selection = Vector2(0, 0)
	update_selection()
		
func _some_button_pressed(button):
	toggle_button(button.name)

	
func _input(event : InputEvent):
	if event.is_action_pressed("ui_left"):
		if current_selection.x == 2:
			current_selection += Vector2(0, -1)
		current_selection += Vector2(0, -1)
	elif event.is_action_pressed("ui_right"):
		if current_selection.x == 2:
			current_selection += Vector2(0, 1)
		current_selection += Vector2(0, 1)
	elif event.is_action_pressed("ui_up"):
		current_selection += Vector2(-1, 0)
	elif event.is_action_pressed("ui_down"):
		if current_selection.x == 1:
			clamp(current_selection.y, 0, 1)
		current_selection += Vector2(1, 0)
	elif event.is_action_pressed("ui_select"):
		if current_selection.x == 2:
			if current_selection.y == 0:
				_on_back_pressed()
			elif current_selection.y == 1:
				_on_forward_pressed()
		else:
			toggle_button(button_grid[current_selection.x][current_selection.y])
	update_selection()
	update_selection_box()

# Clears buttons (only necessary when people try to click buttons after 
# selecting 3
func clear_button_highlights():
	for button in all_buttons:
		if not button in selected_characters:
			button_map[button].set_pressed(false)
			
# Updates the currently selected button (keyboard)
func update_selection():
	current_selection.x = clamp(current_selection.x, 0, 2)
	current_selection.y = clamp(current_selection.y, 0, ROW_SIZE - 1)
	if current_selection.x != 2:
		$GridContainer/highlight.position = _convert_pos(current_selection)
		$GridContainer/highlight.scale = Vector2(1, 1)
		$Stats.load_unit(cmap[button_grid[current_selection.x][current_selection.y]].instance())
	else:
		if current_selection.y == 0:
			$GridContainer/highlight.position = Vector2(0, 455)
		else:
			$GridContainer/highlight.position = Vector2(834, 455)
		$GridContainer/highlight.scale = Vector2(.91, 0.454)

# Pos on button grid to pos on screen
func _convert_pos(pos : Vector2):
	#0, 0 = 81, 70. + 204 for xy
	return Vector2(pos.y * 204, pos.x * 204)
	

func toggle_button(button_id):
	if selection_map[button_id]:
		if num_selected == 3:
			for id in button_map:
				button_map[id].disabled = false
		selection_map[button_id] = false
		num_selected -= 1
		selected_characters.erase(button_id)
		button_map[button_id].set_pressed(false)
	else:
		button_map[button_id].set_pressed(true)
		if num_selected < 3:
			selection_map[button_id] = true
			num_selected += 1
			selected_characters.append(button_id)
		if num_selected == 3:
			for id in button_map:
				if not id in selected_characters:
					button_map[id].disabled = true
	update_selection_box()
	clear_button_highlights()

func update_selection_box():
	clear_selections()
	var desired_size = Vector2(128, 128)
	var actual_size = Vector2(200, 200)
	var scale_vector = desired_size / actual_size
	for i in range(len(selected_characters)):
		selection_boxes[i].set_texture(load(button_map[selected_characters[i]].get_normal_texture().resource_path))
		selection_boxes[i].scale = scale_vector

func clear_selections():
	for selection in selection_boxes:
		selection.set_texture(null)	

func _on_back_pressed():
	get_tree().change_scene("res://assets/scenes/main_menu.tscn")

func _on_forward_pressed():
	var characters = []
	for c in selected_characters:
		characters.append(cmap[c].instance())
	Globals.player_characters = characters
	get_tree().change_scene("res://assets/scenes/game.tscn")
	
