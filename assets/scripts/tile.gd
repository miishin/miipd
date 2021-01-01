extends Node2D
class_name Tile

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
var neighbors = []

# Called when the node enters the scene tree for the first time.
func _ready():
	passable = true
	
# Place tile at a
func place(pos_vector):
	pos = pos_vector

func set_top_neighbor(tile):
	top_neighbor = tile
	neighbors.append(top_neighbor)
	
func set_bottom_neighbor(tile):
	bottom_neighbor = tile
	neighbors.append(bottom_neighbor)

func set_left_neighbor(tile):
	left_neighbor = tile
	neighbors.append(left_neighbor)

func set_right_neighbor(tile):
	right_neighbor = tile
	neighbors.append(right_neighbor)

func get_neighbors():
	return neighbors
	
func is_passable():
	return passable
	
func highlight():
	$Highlight.visible = true
	
func unhighlight():
	$Highlight.visible = false

func is_highlighted():
	return $Highlight.visible

func toggle_highlight():
	$Highlight.visible = not $Highlight.visible

func toggle_passable():
	passable = not passable

func select():
	$SelectLight.visible = true

func deselect():
	$SelectLight.visible = false
