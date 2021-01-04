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
func _ready() -> void:
	passable = true
	
# Place tile at a
func set_pos(pos_vector: Vector2) -> void:
	pos = pos_vector

func set_top_neighbor(tile: Tile) -> void:
	top_neighbor = tile
	neighbors.append(top_neighbor)
	
func set_bottom_neighbor(tile: Tile) -> void:
	bottom_neighbor = tile
	neighbors.append(bottom_neighbor)

func set_left_neighbor(tile: Tile) -> void:
	left_neighbor = tile
	neighbors.append(left_neighbor)

func set_right_neighbor(tile: Tile) -> void:
	right_neighbor = tile
	neighbors.append(right_neighbor)

func get_neighbors() -> Array:
	return neighbors
	
func is_passable() -> bool:
	return passable
	
func highlight() -> void:
	$Highlight.visible = true
	
func unhighlight() -> void:
	$Highlight.visible = false

func is_highlighted() -> bool:
	return $Highlight.visible

func toggle_highlight() -> void:
	$Highlight.visible = not $Highlight.visible

func toggle_passable() -> void:
	passable = not passable

func select() -> void:
	$SelectLight.visible = true

func deselect() -> void:
	$SelectLight.visible = false
