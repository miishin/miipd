extends Node

var player_characters

var playing     : bool
var tween_count : int

var yielded_animations = []

var ability_map = {
	"bash": make_ability("Bash", 5, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 1, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"slash": make_ability("Slash", 3, Ability.RangeAngle.FULL, Vector2(2, 3), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"pinch" : make_ability("Pinch", 100, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 1, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"dash_slice" : make_ability("Dash Slice", 2, Ability.RangeAngle.PERPENDICULAR, Vector2(2, 10), Ability.AoeType.LINE, 0, Ability.AbilityTarget.EMPTY, Ability.Debuff.NONE),
	"rave" : make_ability("Crab Rave", 1000, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	"lay_egg" : make_ability("Lay Egg", 0, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.EMPTY, Ability.Debuff.NONE),
	"birds_with_arms" : make_ability("Birds With Arms", 4, Ability.RangeAngle.FULL, Vector2(1, 4), Ability.AoeType.LINE, -2, Ability.AbilityTarget.ALL_UNITS, Ability.Debuff.NONE),
	"retweet" : make_ability("Retweet", 0, Ability.RangeAngle.FULL, Vector2(1, 3), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALL_UNITS, Ability.Debuff.NONE),
	"tail_swipe" : make_ability("Tail Swipe", 4, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	"spit" : make_ability("Spit", 1, Ability.RangeAngle.FULL, Vector2(1, 8), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.ALL, Ability.Debuff.ROOT),
	"leap" : make_ability("Leap", 3, Ability.RangeAngle.FULL, Vector2(1, 4), Ability.AoeType.CIRCULAR, 2, Ability.AbilityTarget.EMPTY, Ability.Debuff.NONE),
	"eat" : make_ability("Eat", 0, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY, Ability.Debuff.CONSUMED),
	"vomit" : make_ability("Vomit", 5, Ability.RangeAngle.FULL, Vector2(1, 10), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"digest" : make_ability("Digest", -5, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	"sting" : make_ability("Sting", 6, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"buzz" : make_ability("Buzz", -5, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.NONE),
	"missile" : make_ability("AGM-64HORNET Missile", 2, Ability.RangeAngle.FULL, Vector2(4, 4), Ability.AoeType.CIRCULAR, 3, Ability.AbilityTarget.ALL, Ability.Debuff.NONE),
	"shell_up" : make_ability("Shell Up", 0, Ability.RangeAngle.FULL, Vector2(0, 0), Ability.AoeType.CIRCULAR, 0, Ability.AbilityTarget.ALLY, Ability.Debuff.ROOT),
	# Turtle ones need work to figure out
}

static func make_ability(name, dmg, angle, ability_range, aoe_type, aoe, target, debuff) -> Ability:
	var ability = Ability.new(name, dmg, angle, ability_range, aoe_type, aoe, target, debuff)
	return ability
