extends Node2D

const game_window = preload("res://assets/scenes/game_window.tscn")
const hamster = preload("res://assets/scenes/units/hamster.tscn")

var window
var player_units
var stage_number

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init([hamster.instance()])

func init(player_units: Array) -> void:
	stage_number = 0
	var board = Board.new(7, 7)
	set_coordinates(board, player_units)
	window = game_window.instance()
	window.init(board, player_units)
	add_child(window)

func set_coordinates(b : Board, player_units: Array) -> void:
	for p in player_units:
		p.position = b.convert_coordinate(Vector2(0, 0))
