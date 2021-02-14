extends Node2D
class_name Unit

const MOVE_TIME = 0.25

var occupied_tile : Vector2
var sprite = null

var spd : int = (randi() % 10) + 1
var hp  : int = 10
var atk : int = 2
var def : int = 1
var mov : int = 2
var og_mov : int = mov
var aggro : int = 0

var buff   : int
var debuff : int

var debuff_counter : int = 0
var buff_counter   : int = 0

var abilities : Array

func _ready() -> void:
	init_abilities()
	for child in get_children():
		if child is AnimatedSprite or child is Sprite:
			sprite = child
			break

func init_abilities():
	abilities.append(Globals.ability_map["bash"])
	abilities.append(Globals.ability_map["slash"])
	
func end_turn():
	if buff != 0:
		buff_counter -= 1
		if buff_counter == 0:
			buff = 0
	if debuff != 0:
		debuff_counter -= 1
		if debuff_counter == 0:
			debuff = 0
			reset_mov()

func reset_mov():
	mov = og_mov

func move(start : Vector2, end : Vector2, delay : float = 0) -> void:
	$Tween.interpolate_property(self, "position",
		start, end, MOVE_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	$Tween.start()

func move_path(positions: Array) -> void:
	while Globals.playing:
		yield()
	Globals.playing = true
	Globals.tween_count = len(positions)
	for i in range(len(positions)):
		var start = self.position
		if i > 0:
			start = positions[i-1]
		move(start, positions[i], i * MOVE_TIME)

func get_size() -> Vector2:
	if sprite is AnimatedSprite:
		var sprite_frames : SpriteFrames
		sprite_frames = sprite.get_sprite_frames()
		return sprite_frames.get_frame(sprite_frames.get_animation_names()[0], 0).get_size()
	if sprite is Sprite:
		return sprite.texture.get_size()
	return Vector2(0,0)
	
func clone() -> Unit:
	var dup = get_script().new()
	dup.spd = self.spd
	dup.sprite = self.sprite
	dup.add_child(dup.sprite.duplicate())
	return dup

func _on_tween_completed(_object, _key):
	Globals.tween_count -= 1
	if Globals.tween_count == 0:
		Globals.playing = false
		if len(Globals.yielded_animations) > 0:
			var yielded = Globals.yielded_animations.pop_front()
			yielded.resume()

func dead():
	return hp <= 0
