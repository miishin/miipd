extends Node2D

# Position of Tile (on Board)
var pos

# Whether units can pass through this tile (impassable tiles will
# have some barrier unit placed on it).
var passable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Place tile at a
func place(pos_x, pos_y):
	pos = Vector2(pos_x, pos_y)

