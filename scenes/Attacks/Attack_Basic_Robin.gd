extends Node

var basic_attack = true
var fight

var duration = 0.4
var active_enemy
var target_birb
var damage

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

var sounds = [
	preload("res://sounds/dialogue_autotune_long-001.wav"),
	preload("res://sounds/dialogue_autotune_long-003.wav"),
	preload("res://sounds/dialogue_autotune_long-005.wav"),
	preload("res://sounds/dialogue_autotune_long-007.wav"),
	preload("res://sounds/dialogue_autotune_long-009.wav")
]

func _ready():
	pass

func init(active, target, amount):
	active_enemy = active
	target_birb = target
	damage = amount
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(helpers.rand_choice(sounds))
		var p = preload("res://scenes/Particles/Particle_Robin.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy), helpers.default_birb_pos(target_birb))
		fight.add_child(p)
	
	if helpers.this_frame(0.35, elapsed, delta):
		fight.damage_birb(active_enemy, target_birb, damage)
		fight.start_screen_shake(10)
	
	return elapsed >= duration
