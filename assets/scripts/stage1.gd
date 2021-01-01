extends Board

var enemy_units

func _init().(6, 6):
	form_stage()

# Create enemy units and obstacles on the Board
func form_stage():
	generate_enemies()
	create_obstacles()
	
func generate_enemies():
	pass

func create_obstacles():
	pass
