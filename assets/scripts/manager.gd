extends Node2D

const game_window = preload("res://assets/scenes/game_window.tscn")

var window
var player_units
var stage_number

# Called when the node enters the scene tree for the first time.
func _ready():
	init([])

func init(player_units):
	stage_number = 0
	var board = Board.new(7, 7)
	window = game_window.instance()
	window.init(board, player_units)
	add_child(window)
