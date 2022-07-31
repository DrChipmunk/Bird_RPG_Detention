extends Node

var fight

var duration = 0.5
var active_enemy
var target_enemy
var amount

var elapsed

var sounds = [
	preload("res://sounds/coo-002.wav"),
	preload("res://sounds/coo-008.wav"),
	preload("res://sounds/coo-010.wav"),
	preload("res://sounds/coo-013.wav"),
	preload("res://sounds/coo-014.wav")
]

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, target, _amount):
	active_enemy = active
	amount = _amount
	target_enemy = target
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(helpers.rand_choice(sounds))
		for _i in range(4):
			var p = preload("res://scenes/Particles/Particle_Coo.tscn").instance()
			p.init(helpers.default_enemy_pos(active_enemy), helpers.default_enemy_pos(target_enemy))
			fight.add_child(p)
	
	if helpers.this_frame(0.45, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/guard_v2-002.wav"))
		fight.enemies[target_enemy].increase_effect("defence", amount)
		var p = preload("res://scenes/Particles/Particle_Guard.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy) + Vector2(-20, 0), true)
		fight.add_child(p)
		fight.start_screen_shake(10)
	
	return elapsed >= duration
