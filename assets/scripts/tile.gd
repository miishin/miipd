extends Node2D


var x
var y


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Place tile at a
func place(pos_x, pos_y):
	x = pos_x
	y = pos_y

