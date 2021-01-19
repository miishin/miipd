extends Node

var player_characters

var playing     : bool
var tween_count : int

var yielded_animations = []

var ability_map = {
	"bash": make_ability("Bash", 5, Ability.RangeAngle.FULL, Vector2(1, 1), Ability.AoEType.CIRCULAR, 1, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
	"slash": make_ability("Slash", 3, Ability.RangeAngle.FULL, Vector2(2, 3), Ability.AoEType.CIRCULAR, 2, Ability.AbilityTarget.ENEMY, Ability.Debuff.NONE),
}

static func make_ability(name, dmg, angle, ability_range, aoe_type, aoe, target, debuff) -> Ability:
	var ability = Ability.new(name, dmg, angle, ability_range, aoe_type, aoe, target, debuff)
	return ability
