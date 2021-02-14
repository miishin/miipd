extends Unit

func _ready():
	mov = 0

func init_abilities():
	abilities.append(Globals.ability_map["pinch"])
	abilities.append(Globals.ability_map["dash_slice"])
	abilities.append(Globals.ability_map["rave"])
