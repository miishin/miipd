extends Node2D
class_name Ability

# ANY - Ability can target any tile within its range
# FIXED - Ability can only target tiles at its range (exactly n tiles)
enum RangeType {ANY, FIXED}

# Abilities target on the XY axis or diagonally or both
enum RangeAngle {PERPENDICULAR, DIAGONAL, FULL}

# Range of ability in tiles
var ability_range : int

# Size of AoE of ability (AoE = 1 for singular target) in tiles
var aoe : int

# Type of AoE. If aoe size is n:
# Circular: all tiles reachable in n tiles
# Line: all tiles back towards caster (simulate a line aoe attack) aoe = range
# Perpendicular: n tiles in perpendicular directions
# Diagonal: n tiles in diagonal directions
enum AoEType {CIRCULAR, LINE, PERPENDICULAR, DIAGONAL}

# Whether this ability targets allies, enemies, or both
enum AbilityTarget {ALLY, ENEMY, ALL}

# Tooltip/description of ability
var description : String

# How much damage this ability does
# If AoE this is damage per tile
# Negative damage = a heal
var damage : int

# The type of debuff this ability inflicts
enum Debuff {NONE}

# Accuracy (% to hit )
var accuracy : int
