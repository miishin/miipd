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

# Name of the ability
var title : String

func _init(name, dmg, angle, ab_range, aoe_enum, aoe_range, target_enum, debuff_enum):
	title = name
	damage = dmg
	range_angle = angle
	ability_range = ab_range
	aoe_type = aoe_enum
	aoe = aoe_range
	target = target_enum
	debuff = debuff_enum
	description = "Does " + str(dmg) + " damage"	
