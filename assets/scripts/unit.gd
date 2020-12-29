extends Node2D

class_name Unit
var occupied_tile

var hp = 10
var atk = 2
var def = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fight(other : Unit):
	other.hp -= (self.atk - other.def)

func move(pos):
	$Tween.interpolate_property(self, "position",
		self.position, pos, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
