extends ViewportContainer

var speed : float = 0.0
const SCROLL_SPEED : float = 10.0
const SCROLL_DECCELERATION : float = 2.0
const SCROLL_MAX_SPEED : float = 100.0

func _process(delta : float) -> void:
	speed = lerp(speed, 0.0, SCROLL_DECCELERATION * delta)
	
func _input(event : InputEvent) -> void:
	if event.is_action("ui_left"):
		speed = clamp(speed - SCROLL_SPEED, -SCROLL_MAX_SPEED, SCROLL_MAX_SPEED)
	elif event.is_action("ui_right"):
		speed = clamp(speed + SCROLL_SPEED, -SCROLL_MAX_SPEED, SCROLL_MAX_SPEED)
