extends Unit

func init_abilities():
	abilities.append(Globals.ability_map("eat"))
	abilities.append(Globals.ability_map("vomit"))
	abilities.append(Globals.ability_map("digest"))
