extends Node2D

const MOVE_TIME = 0.25

class_name Unit
var occupied_tile

var hp = 10
var atk = 2
var def = 1
var mov = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fight(other : Unit):
	other.hp -= (self.atk - other.def)

func move(start, end, delay = 0):
	$Tween.interpolate_property(self, "position",
		start, end, MOVE_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	$Tween.start()

func move_path(positions):
	for i in range(len(positions)):
		var start = self.position
		if i > 0:
			start = positions[i-1]
		move(start, positions[i], i * MOVE_TIME) 
