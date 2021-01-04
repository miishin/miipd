extends Control

var possible_characters

func _input(event : InputEvent):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://assets/scenes/game.tscn")
