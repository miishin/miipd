extends Node2D

const game_window = preload("res://assets/scenes/game_window.tscn")
const hamster = preload("res://assets/scenes/units/hamster.tscn")

var window
var player_units
var stage_number

# Called when the node enters the scene tree for the first time.
func _ready():
	init([hamster.instance()])

func init(player_units):
	stage_number = 0
	var board = Board.new(7, 7)
	set_coordinates(player_units, board)
	window = game_window.instance()
	window.init(board, player_units)
	add_child(window)

func set_coordinates(player_units, b : Board):
	for p in player_units:
		p.position = b.convert_coordinate(Vector2(0, 0))
