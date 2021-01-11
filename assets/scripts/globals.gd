extends Node

var player_characters

var playing     : bool
var tween_count : int

var yielded_animations = []

var ability_map = {
	"bash": make_ability(2, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoEType.CIRCULAR, 0, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
}

static func make_ability(dmg, angle, ability_range, aoe_type, aoe, target, debuff) -> Ability:
	var ability = Ability.new(dmg, angle, ability_range, aoe_type, aoe, target, debuff)
	return ability
