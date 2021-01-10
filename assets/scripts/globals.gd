extends Node

var player_characters

var playing     : bool
var tween_count : int

var yielded_animations = []

var ability_map = {
	"bash": make_ability(2, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoEType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE, 90),
}

static func make_ability(dmg, angle, ability_range, aoe_type, aoe, target, debuff, acc) -> Ability:
	var ability = Ability.new()
	ability.damage = dmg
	ability.range_angle = angle
	ability.ability_range = ability_range
	ability.aoe_type = aoe_type
	ability.aoe = aoe
	ability.target = target
	ability.debuff = debuff
	ability.accuracy = acc
	ability.description = "Does " + str(dmg) + " damage"
	return ability
