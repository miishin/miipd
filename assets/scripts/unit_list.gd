extends Node2D
class_name UnitList

const SPACING = 0

var units = []

func _ready():
	update()

func add_unit(unit : Unit):
	if len(units) == 0:
		unit.position.x = 0
	else:
		unit.position.x = units[-1].position.x + units[-1].get_size().x + SPACING
	units.append(unit)
	add_child(unit)

func update():
	var start = 0
	for unit in units:
		assert(unit is Unit)
		unit.position.x = start
		start += unit.get_size().x + SPACING
		
func delete_unit(unit : Unit):
	units.erase(unit)