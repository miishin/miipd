extends Node2D

var units # for showing turn order
var tiles

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _move(unit, tile):
	unit.move_to(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# in unit.gd

func move_to(tile):
	position_tile = tile


func in_range(tile_origin, tile_dest, dist):
	# check if tile is within range <= dist
	pass
