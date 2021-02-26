extends Node2D
class_name UnitList

const SPACING = 0

var rng = RandomNumberGenerator.new()
var units : Array = []
var total_speed : int
var queue : Array = []

func _ready():
	update()

func _init(units : Array):
	units = units
	for unit in units:
		total_speed += unit.spd
	generate_next_n_units(5)
	

func add_unit(unit : Unit):
	units.append(unit)
	total_speed += unit.spd
	
func remove_unit(unit : Unit):
	units.erase(unit)
	queue.erase(unit)
	total_speed -= unit.spd

func generate_next_n_units(n : int):
	for i in range(n):
		queue.append(generate_next_unit())
	
func generate_next_unit() -> Unit:
	rng.randomize()
	var next = rng.randf_range(0, total_speed)
	return _find_unit(next)
	
func _find_unit(speed : int) -> Unit:
	var counter = 0
	for unit in units:
		if speed < unit.spd + counter:
			return unit
		counter += unit.spd
	print("uh oh")
	return null

func next_unit() -> Unit:
	return queue[0]
	
func rotate_queue():
	queue.pop_front()
	queue.append(generate_next_unit())

func display():
	var start = 0
	for unit in queue:
		assert(unit is Unit)
		unit.position.x = start
		start += unit.get_size().x + SPACING
