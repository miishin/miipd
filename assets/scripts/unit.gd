extends Node2D

class_name Unit
var occupied_tile

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func move(x, y):
	$Tween.interpolate_property(self, "position",
		self.position, Vector2(x, y), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
