extends Node
class_name Modifier

var duration : int
var id       : int
var delta    : int
var field    : String

var prev

enum Modifiers {NONE, ROOT, CONSUMED, FULL, IMMUNE, AGGRO_UP}

func _init(i, f : String, del : int, dur : int):
	duration = dur
	id = i
	field = f
	delta = del
	
func on_application(unit):
	if field != "":
		prev = unit.get(field)
		if delta == 0:
			unit.set(field, delta)
		else:
			unit.set(field, prev + delta)
	
func on_expiration(unit):
	if field != "":
		if delta == 0:
			unit.set(field, prev)
		else:
			unit.set(field, unit.get(field) - delta)
	unit.modifiers.erase(self)

func inc_turn(unit):
	duration -= 1
	if duration == 0:
		on_expiration(unit)
