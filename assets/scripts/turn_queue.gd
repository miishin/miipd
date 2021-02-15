extends Node
class_name TurnQueue

var rng = RandomNumberGenerator.new()
var units : Array
var total_speed : int
var queue : Array

func _init(units : Array):
	units = units
	for unit in units:
		total_speed += unit.spd
	queue = []
	generate_next_units(5)

func add_unit(unit : Unit):
	units.append(unit)
	total_speed += unit.spd

func remove_unit(unit : Unit):
	units.erase(unit)
	queue.erase(unit)
	total_speed -= unit.spd

func generate_next_units(n : int):
	for i in range(n):
		queue.append(next_unit())
		
func next_unit() -> Unit:
	rng.randomize()
	var next = rng.randf_range(1, total_speed)
	return _find_unit(next)
	
func _find_unit(speed : int) -> Unit:
	var counter = 0
	for unit in units:
		if speed < unit.spd + counter:
			return unit
		counter += unit.spd
	return null
	
func increment_turn():
	queue.pop_front()
	queue.append(next_unit())
