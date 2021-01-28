extends Control
var bee = preload("res://assets/scenes/units/bee.tscn")

# Remove later.
func _ready():
	var b = bee.instance()
	b.init_abilities()
	load_unit(b)
	
# Takes in a unit and sets this windows data accordingly
func load_unit(unit : Unit):
	_set_hp(unit.hp)
	_set_atk(unit.atk)
	_set_def(unit.def)
	_set_spd(unit.spd)
	_set_mov(unit.mov)
	_set_ability1(unit.abilities[0])
	_set_ability2(unit.abilities[1])
	#_set_ability3(unit.abilities[2])
	# This may not be correct, will test when all units have actual animatedsprites	
	#$CharSprite.texture.set_frame_texture(0, unit.sprite.get_sprite_frames()[0])
	#$CharSprite.texture.set_frame_texture(1, unit.sprite.get_sprite_frames()[1])
	
	
func _set_hp(hp : int):
	$Stats/HitPoints.set_text("HP: %d" % hp)

func _set_atk(atk : int):
	$Stats/Attack.set_text("ATK: %d" % atk)

func _set_def(def : int):
	$Stats/Defense.set_text("DEF: %d" % def)
	
func _set_spd(spd : int):
	$Stats/Speed.set_text("SPD: %d" % spd)
	
func _set_mov(mov : int):
	$Stats/Movement.set_text("MOV: %d" % mov)
	
func _set_ability1(ability : Ability):
	$Abilities/Ability1.set_text(ability.description)
	
func _set_ability2(ability: Ability):
	$Abilities/Ability2.set_text(ability.description)
	
func _set_ability3(ability : Ability):
	$Abilities/Ability3.set_text(ability.description)
