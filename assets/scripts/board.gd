extends Node2D

var units # for showing turn order
var tiles = []
# Offset so Board isn't stuck to top of screen
const OFFSET = 150


# Called when the node enters the scene tree for the first time.
func _ready():
	pass #

# Instantiate board tiles
func init():
	pass
	
# Converts from the coordinate on the board to the coordinate
# on the screen. 
# One tile in the x direction = +62.5x, +31y
# One tile in the y direction = -62.5x, +31y
func convert_coordinate(x, y):
	var new_x
	var new_y
	new_x = 62.5 * x - 62.5 * y
	new_y = 31 * (x + y) + OFFSET
	return [new_x, new_y]

func in_range(tile_origin, tile_dest, dist):
	# check if tile is within range <= dist
	pass
