extends 'res://addons/gut/test.gd'

var _board = null

func before_each():
	_board = Board.new(7, 7)
	
