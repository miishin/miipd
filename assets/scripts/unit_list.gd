extends Node2D
class_name UnitList

const SPACING = 0

var rng = RandomNumberGenerator.new()
var all_units : Array = []
var total_speed : int
var queue : Array = []
var queue_sprites : Array = [
	$Sprites/Sprite1,
	$Sprites/Sprite2,
	$Sprites/Sprite3,
	$Sprites/Sprite4,
	$Sprites/Sprite5,
]

func _init(units : Array):
	all_units = units
	for unit in all_units:
		total_speed += unit.spd
	generate_next_n_units(5)
	
	display()

func add_unit(unit : Unit):
	all_units.append(unit)
	total_speed += unit.spd
	
func remove_unit(unit : Unit):
	all_units.erase(unit)
	queue.erase(unit)
	total_speed -= unit.spd

func generate_next_n_units(n : int):
	for i in range(n):
		queue.append(generate_next_unit())
	
func generate_next_unit() -> Unit:
	rng.randomize()
	var next = rng.randf_range(1, total_speed)
	return _find_unit(next)
	
func _find_unit(speed : int) -> Unit:
	var counter = 1
	for unit in all_units:
		counter += unit.spd
		if speed < counter:
			return unit
	return null

func next_unit() -> Unit:
	return queue[0]
	
func rotate_queue():
	queue.pop_front()
	queue.append(generate_next_unit())

func display():
	var start = 0
	for i in range(5):
		var sprite = queue[i].get_children()[2]
		queue_sprites[i].set_texture(sprite.texture)
