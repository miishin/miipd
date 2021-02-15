extends Node
class_name Modifier

var duration : int
var id : int
enum Modifiers {NONE, ROOT, CONSUMED, FULL, IMMUNE, AGGRO_UP}
var func_names = ["root", "consumed", "full", "immune", "aggro_up"]

func init(d : int, id):
	duration = d
	id = id
	
func on_application(unit : Unit):
	call("apply_" + func_names[id], unit)
	
func on_expiration(unit : Unit):
	call("clear_" + func_names[id], unit)
	unit.modifiers.erase(self)

func inc_turn(unit : Unit):
	duration -= 1
	if duration == 0:
		on_expiration(unit)

func apply_immune(unit : Unit):
	pass
	
func clear_immune(unit : Unit):
	pass
	
func apply_root(unit : Unit):
	pass

func clear_root(unit : Unit):
	pass
	
func apply_full(unit : Unit):
	pass

func clear_full(unit : Unit):
	pass

func apply_consumed(unit : Unit):
	pass

func clear_consumed(unit : Unit):
	pass
	
func apply_aggro_up(unit : Unit):
	unit.aggro += 2

func clear_aggro_up(unit : Unit):
	unit.aggro -= 2

### Constructors ###
static func make_immune(d : int):
	return Modifier.instance(d, Modifiers.IMMUNE)

static func make_root(d : int):
	return Modifier.instance(d, Modifiers.ROOT)
	
static func make_full(d : int):
	return Modifier.instance(d, Modifiers.FULL)
	
static func make_consumed(d : int):
	return Modifier.instance(d, Modifiers.CONSUMED)
	
static func make_aggro_up(d : int):
	return Modifier.instance(d, Modifiers.AGGRO_UP)

