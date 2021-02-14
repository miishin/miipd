extends Node

var player_characters

var playing     : bool
var tween_count : int

var yielded_animations = []

var ability_map = {
	"bash": make_ability("Bash", 5, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 1, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"slash": make_ability("Slash", 3, Ability.RangeAngle.FULL, Vector2(2, 3), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"pinch" : make_ability("Pinch", 100, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 1, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"dash_slice" : make_ability("Dash Slice", 2, Ability.RangeAngle.PERPENDICULAR, Vector2(2, 10), Ability.AoeType.LINE, 0, Ability.AbilityTarget.EMPTY, Ability.Debuff.NONE, true),
	"rave" : make_ability("Crab Rave", 1000, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	"lay_egg" : make_ability("Lay Egg", 0, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.EMPTY, Ability.Debuff.NONE),
	"birds_with_arms" : make_ability("Birds With Arms", 4, Ability.RangeAngle.FULL, Vector2(1, 4), Ability.AoeType.LINE, -2, Ability.AbilityTarget.ALL_UNITS, Ability.Debuff.NONE),
	"retweet" : make_ability("Retweet", 0, Ability.RangeAngle.FULL, Vector2(1, 3), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALL_UNITS, Ability.Debuff.NONE),
	"tail_swipe" : make_ability("Tail Swipe", 4, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	"spit" : make_ability("Spit", 1, Ability.RangeAngle.FULL, Vector2(1, 8), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ALL, Ability.Debuff.ROOT),
	"leap" : make_ability("Leap", 3, Ability.RangeAngle.FULL, Vector2(1, 4), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.EMPTY, Ability.Debuff.NONE, true),
	"eat" : make_ability("Eat", 100000, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY, Ability.Debuff.CONSUMED),
	"vomit" : make_ability("Vomit", 5, Ability.RangeAngle.FULL, Vector2(1, 10), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"digest" : make_ability("Digest", -5, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	"sting" : make_ability("Sting", 6, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"buzz" : make_ability("Buzz", -5, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	"missile" : make_ability("AGM-64HORNET Missile", 2, Ability.RangeAngle.FULL, Vector2(4, 4), Ability.AoeType.CIRCULAR, 3, Ability.AbilityTarget.ALL, Ability.Debuff.NONE),
	"shell_up" : make_ability("Shell In", 0, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.ROOT),
	"shell_out" : make_ability("Shell Out", 0, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	# Turtle ones need work to figure out
}


var special_abilities = {
	"retweet"   : true,
	"eat"       : true,
	"vomit"     : true,
	"rave"      : true,
	"lay_egg"   : true,
	"shell_up"  : true,
	"shell_out" : true,
}

static func make_ability(name, dmg, angle, ability_range, aoe_type, aoe, target, debuff, moves = false) -> Ability:
	var ability = Ability.new(name, dmg, angle, ability_range, aoe_type, aoe, target, debuff, moves)
	return ability
