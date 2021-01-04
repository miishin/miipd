extends Control


func _ready():
	randomize()
	pass

func _on_quit_pressed():
	get_tree().quit(0)


func _on_start_pressed():
	get_tree().change_scene("res://assets/scenes/character_select.tscn")
