extends Control

const SPEED = 500

var input = Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(delta):
	var selection = $Panel/Selection
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = input.normalized()

	selection.move_and_slide(velocity * SPEED)
