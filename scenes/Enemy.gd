extends Sprite

var hp
var max_hp
var effects
var attacks

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(_max_hp):
	max_hp = _max_hp
	hp = max_hp
	attacks = []
	effects = {}
	for effect in get_parent().effects:
		effects[effect] = 0
	visible = true
	var children = get_children()
	for child in children:
		child.queue_free()
	self_modulate.a = 1

func increase_effect(effect, amount):
	if hp > 0:
		effects[effect] += amount

func change_attacks():
	for attack in attacks:
		var other = get_parent().other_random_living_birb(attack.target_birb)
		if other != -1:
			attack.target_birb = other

func _process(delta):
	if hp <= 0:
		visible = false
		
var sprites_1 = [
	preload("res://sprites/bone_construct_1a.png"),
	preload("res://sprites/bone_construct_1b.png")
]
var sprites_2 = [
	preload("res://sprites/bone_construct_2a.png"),
	preload("res://sprites/bone_construct_2b.png")
]
var sprites_3 = [
	preload("res://sprites/bone_construct_3a.png"),
	preload("res://sprites/bone_construct_3b.png")
]
var sprites_4 = [
	preload("res://sprites/bone_construct_4a.png"),
	preload("res://sprites/bone_construct_4b.png")
]
		
func add_bone_sprites():
	var children = get_children()
	for child in children:
		child.queue_free()
	var s1 = Sprite.new()
	s1.texture = helpers.rand_choice(sprites_1)
	s1.offset = offset + Vector2(-16,-16)
	add_child(s1)
	var s2 = Sprite.new()
	s2.texture = helpers.rand_choice(sprites_2)
	s2.offset = offset + Vector2(16,-16)
	add_child(s2)
	var s3 = Sprite.new()
	s3.texture = helpers.rand_choice(sprites_3)
	s3.offset = offset + Vector2(-16,16)
	add_child(s3)
	var s4 = Sprite.new()
	s4.texture = helpers.rand_choice(sprites_4)
	s4.offset = offset + Vector2(16,16)
	add_child(s4)
