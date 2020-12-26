extends Node2D

var units # for showing turn order
var tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	pass #

# Converts from the coordinate on the board to the coordinate
# on the screen. 
func convert_coordinate(x, y):
	pass

func in_range(tile_origin, tile_dest, dist):
	# check if tile is within range <= dist
	pass
