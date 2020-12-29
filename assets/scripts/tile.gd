extends Node2D

# Position of Tile (on Board)
var pos

# Whether units can pass through this tile (impassable tiles will
# have some barrier unit placed on it).
var passable

# Neighboring tiles
var top_neighbor
var bottom_neighbor
var left_neighbor
var right_neighbor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Place tile at a
func place(pos_vector):
	pos = pos_vector

func set_top_neighbor(tile):
	top_neighbor = tile
	
func set_bottom_neighbor(tile):
	bottom_neighbor= tile

func set_left_neighbor(tile):
	left_neighbor= tile

func set_right_neighbor(tile):
	right_neighbor= tile

func get_neighbors():
	return [top_neighbor, right_neighbor, bottom_neighbor, left_neighbor]
