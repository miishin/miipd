extends Node2D
class_name Ability

# Abilities target on the XY axis or diagonally or both
enum RangeAngle {PERPENDICULAR, DIAGONAL, FULL}

# Type of AoE. If aoe size is n:
# Circular: all tiles reachable in n tiles
# Line: all tiles back towards caster (simulate a line aoe attack) aoe = range
# Perpendicular: n tiles in perpendicular directions
# Diagonal: n tiles in diagonal directions
enum AoEType {CIRCULAR, LINE, PERPENDICULAR, DIAGONAL}

# Whether this ability targets allies, enemies, or both
enum AbilityTarget {ALLY, ENEMY, ALL}

# The type of debuff this ability inflicts
enum Debuff {NONE}

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

# Tooltip/description of ability
var description : String

func _init(dmg, angle, ability_range, aoe_type, aoe, target, debuff):
	damage = dmg
	range_angle = angle
	ability_range = ability_range
	aoe_type = aoe_type
	aoe = aoe
	target = target
	debuff = debuff
	description = "Does " + str(dmg) + " damage"	
	
