extends Node

var duration : int

func init():
	pass
	
func on_application(unit : Unit):
	pass
	
func on_expiration(unit : Unit):
	pass

func inc_turn():
	duration -= 1
	
func modifier_over():
	return duration == 0
