extends Node

var player_characters

var playing     : bool
var tween_count : int

var yielded_animations = []

var ability_map = {
	"bash": make_ability("Bash", 5, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 1, Ability.AbilityTarget.ENEMY),
	"slash": make_ability("Slash", 3, Ability.RangeAngle.FULL, Vector2(2, 3), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ENEMY),
	"pinch" : make_ability("Pinch", 100, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 1, Ability.AbilityTarget.ENEMY),
	"dash_slice" : make_ability("Dash Slice", 2, Ability.RangeAngle.PERPENDICULAR, Vector2(2, 10), Ability.AoeType.LINE, 0, Ability.AbilityTarget.EMPTY, true),
	"rave" : make_ability("Crab Rave", 0, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY),
	"lay_egg" : make_ability("Lay Egg", 0, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.EMPTY),
	"birds_with_arms" : make_ability("Birds With Arms", 4, Ability.RangeAngle.FULL, Vector2(1, 4), Ability.AoeType.LINE, -2, Ability.AbilityTarget.ALL_UNITS),
	"retweet" : make_ability("Retweet", 0, Ability.RangeAngle.FULL, Vector2(1, 3), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALL_UNITS),
	"tail_swipe" : make_ability("Tail Swipe", 4, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ALLY),
	"spit" : make_ability("Spit", 1, Ability.RangeAngle.FULL, Vector2(1, 8), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ALL),
	"leap" : make_ability("Leap", 3, Ability.RangeAngle.FULL, Vector2(1, 4), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.EMPTY, true),
	"eat" : make_ability("Eat", 100000, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY),
	"vomit" : make_ability("Vomit", 5, Ability.RangeAngle.FULL, Vector2(1, 10), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY),
	"digest" : make_ability("Digest", -5, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY),
	"sting" : make_ability("Sting", 6, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY),
	"buzz" : make_ability("Buzz", -5, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY),
	"missile" : make_ability("AGM-64HORNET Missile", 2, Ability.RangeAngle.FULL, Vector2(4, 4), Ability.AoeType.CIRCULAR, 3, Ability.AbilityTarget.ALL),
	"shell_up" : make_ability("Shell In", 0, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY),
	"shell_out" : make_ability("Shell Out", 0, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY),
	# Turtle ones need work to figure out
}

var modifiers = {
	Modifier.Modifiers.AGGRO_UP: make_modifier(Modifier.Modifiers.AGGRO_UP, "aggro", 2, 3),
	Modifier.Modifiers.FULL: make_modifier(Modifier.Modifiers.FULL, "", 0, -1),
	Modifier.Modifiers.CONSUMED: make_modifier(Modifier.Modifiers.CONSUMED, "", 0, -1),
	Modifier.Modifiers.IMMUNE: make_modifier(Modifier.Modifiers.IMMUNE, "", 0, -1),
	Modifier.Modifiers.ROOT: make_modifier(Modifier.Modifiers.ROOT, "mov", 0, -2),
}

var special_abilities = {
	"retweet"   : true,
	"eat"       : true,
	"vomit"     : true,
	"rave"      : true,
	"lay_egg"   : true,
	"shell_up"  : true,
	"shell_out" : true,
	"buzz"      : true,
	"spit"      : true,
}

static func make_modifier(id, field, delta, duration) -> Modifier:
	var modifier = Modifier.new(id, field, delta, duration)
	return modifier

static func make_ability(name, dmg, angle, ability_range, aoe_type, aoe, target, moves = false) -> Ability:
	var ability = Ability.new(name, dmg, angle, ability_range, aoe_type, aoe, target, moves)
	return ability
