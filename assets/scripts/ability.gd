extends Node2D
class_name Ability

# Abilities target on the XY axis or diagonally or both
enum RangeAngle {PERPENDICULAR, DIAGONAL, FULL}

# Type of AoE. If aoe size is n:
# Circular: all tiles reachable in n tiles
# Line: n tiles back towards the caster (n = aoe, negatives = away from caster)
	# aoe = 0 denotes all the way back to the caster (to work with dynamic ranges). 
# Perpendicular: n tiles in perpendicular directions
# Diagonal: n tiles in diagonal directions
enum AoeType {CIRCULAR, LINE}

# Whether this ability targets allies, enemies, or both
enum AbilityTarget {ALLY, ENEMY, ALL_UNITS, EMPTY, ALL}

# The type of debuff this ability inflicts
enum Debuff {NONE, ROOT, CONSUMED}

enum Buff {NONE, FULL, IMMUNE}

# How much damage this ability does
# If AoE this is damage per tile
# Negative damage = a heal
var damage : int

# Range of ability in tiles (min, max)
var ability_range : Vector2

var range_angle : int

var aoe_type : int

var target : int

var debuff : int 

# Size of AoE of ability (AoE = 1 for singular target) in tiles
var aoe : int

# Whether the ability moves the unit or not
var moves : bool

# Tooltip/description of ability
var description : String

# Name of the ability
var title : String

func _init(name, dmg, angle, ab_range, aoe_enum, aoe_range, target_enum, debuff_enum, does_move):
	title = name
	damage = dmg
	range_angle = angle
	ability_range = ab_range
	aoe_type = aoe_enum
	aoe = aoe_range
	target = target_enum
	debuff = debuff_enum
	moves = does_move
	description = "Does " + str(dmg) + " damage"	

func target_apply(unit : Unit, target_unit: Unit):
	if damage <= 0:
		target_unit.hp -= damage
	else:
		target_unit.hp -= (damage  - target_unit.def)

	if target_unit.buff == Buff.IMMUNE:
		negate_damage(target_unit)
	call_special("_target", [unit, target_unit])

func self_apply(unit : Unit, targets : Array, selected : Tile, board : Board):
	if moves:
		var diff : Vector2 = unit.occupied_tile - selected.pos
		var path = board.pathfinder(board.get_tile(unit.occupied_tile), selected, int(diff.abs().dot(Vector2(1, 1))))
		var yielded = unit.move_path(board.tile_coordinates(path))
		if yielded:
			Globals.yielded_animations.push_back(yielded)
		unit.occupied_tile = selected.pos
	call_special("", [unit, targets, selected, board])
	
func call_special(func_suffix, args : Array):
	var id : String
	for k in Globals.ability_map.keys():
		if Globals.ability_map[k] == self:
			id = k
			break
	if Globals.special_abilities.has(id):
		callv(id + func_suffix, args)

func highlight_range(origin : Tile, board : Board):
	board.highlight_tiles(get_range(origin, board))

func unhighlight_range(origin : Tile, board : Board):
	board.unhighlight_tiles(get_range(origin, board))

func get_range(origin : Tile, board : Board) -> Array:
	var range_tiles = []
	match range_angle:
		RangeAngle.FULL:
			return board.find_accessible(origin, int(ability_range.x), int(ability_range.y), true)
		RangeAngle.PERPENDICULAR:
			for i in range(ability_range.x, ability_range.y):
				var a = origin.pos + Vector2(i, 0)
				var b = origin.pos + Vector2(-i, 0)
				var c = origin.pos + Vector2(0, i)
				var d = origin.pos + Vector2(0, -i)
				if a.x >= 0 and a.x < board.num_rows:
					range_tiles.append(board.get_tile(a))
				if b.x >= 0 and b.x < board.num_rows:
					range_tiles.append(board.get_tile(b))
				if c.y >= 0 and c.y < board.num_cols:
					range_tiles.append(board.get_tile(c))
				if d.y >= 0 and d.y < board.num_cols:
					range_tiles.append(board.get_tile(d))
		RangeAngle.DIAGONAL:
			for i in range(ability_range.x, ability_range.y):
				var a = origin.pos + Vector2(i, i)
				var b = origin.pos + Vector2(-i, i)
				var c = origin.pos + Vector2(i, -i)
				var d = origin.pos + Vector2(-i, -i)
				if a.x >= 0 and a.x < board.num_rows:
					range_tiles.append(board.get_tile(a))
				if b.x >= 0 and b.x < board.num_rows:
					range_tiles.append(board.get_tile(b))
				if c.y >= 0 and c.y < board.num_cols:
					range_tiles.append(board.get_tile(c))
				if d.y >= 0 and d.y < board.num_cols:
					range_tiles.append(board.get_tile(d))
	return range_tiles

func get_aoe(unit : Unit, origin : Tile, board : Board) -> Array:
	var aoe_tiles = []
	match aoe_type:
		AoeType.CIRCULAR:
			return board.find_accessible(origin, 0, aoe)
		AoeType.LINE:
			if aoe == 0:
				var diff : Vector2 = origin.pos - unit.occupied_tile 
				if diff.x != 0 and diff.y != 0:
					return aoe_tiles
				aoe_tiles = board.pathfinder(origin, board.get_tile(unit.occupied_tile), int(diff.abs().dot(Vector2(1,1))))
				aoe_tiles.pop_back()
			elif aoe < 0:
				var diff : Vector2 = origin.pos - unit.occupied_tile
				diff = diff.normalized()
				diff = diff.round()
				for i in range(0, abs(aoe)):
					var next_tile : Vector2 = origin.pos + i * diff
					if next_tile.x < 0 or next_tile.y < 0 or \
					next_tile.x >= board.num_rows or next_tile.y >= board.num_cols:
						continue
					aoe_tiles.append(board.get_tile(next_tile))
	return aoe_tiles

func negate_damage(unit : Unit):
	if damage == 0:
		return
	unit.hp += (damage - unit.def)

##################################
# Abilities with special effects #
##################################

func retweet(unit : Unit, targets : Array, selected : Tile, board : Board):
	var ability : Ability = targets[0].abilities[randi() % len(targets[0].abilities)]
	ability.target_apply(unit, targets[0])
	ability.self_apply(unit, targets[0], selected, board)
	print("used ", ability.title)

func shell_up(unit : Unit, _targets : Array, _selected : Tile, _board : Board):
	unit.buff = Buff.IMMUNE
	unit.debuff = Debuff.ROOT
	unit.mov = 0
	unit.buff_counter = 2
	unit.debuff_counter = 2
	
func shell_out(unit : Unit, _targets : Array, _selected : Tile, _board : Board):
	unit.buff = Buff.NONE
	unit.debuff = Debuff.NONE
	unit.reset_mov()
	unit.buff_counter = 0
	unit.debuff_counter = 0

func rave(_unit : Unit, _targets : Array, _selected : Tile, _board : Board):
	pass

func eat_target(unit : Unit, target_unit : Unit):
	if unit.buff == Buff.FULL:
		negate_damage(target_unit)
		print("already full")
	else:
		unit.buff = Buff.FULL
		unit.buff_counter = 2
		print("yum")

func vomit_target(unit : Unit, target_unit : Unit):
	if unit.buff != Buff.FULL:
		negate_damage(target_unit)
		print("nothing to vomit Ì†æÌ¥∑‚Äç‚ôÄÔ∏è")
		return
	unit.buff = Buff.NONE
	print("yucky")

func digest(unit : Unit, _targets : Array, _selected : Tile, _board : Board):
	if unit.buff != Buff.FULL:
		negate_damage(unit)
		return
	unit.buff = Buff.NONE
	print("delicious")

func lay_egg(_unit : Unit, _targets : Array, _selected : Tile, _board : Board):
	pass

func buzz(unit : Unit, _targets : Array, _selected : Tile, _board : Board):
	print("bzz")
	var m = Modifier.make_aggro_up()
	#unit.modifiers.append(m)
	#m.on_application()
	
