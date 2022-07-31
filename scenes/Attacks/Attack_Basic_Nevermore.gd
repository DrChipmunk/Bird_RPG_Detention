extends Node

var basic_attack = true
var fight

var duration = 0.6
var active_enemy
var target_birb
var damage

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/smoke_fade-003.wav"))
		var p = preload("res://scenes/Particles/Particle_Nevermore.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy), helpers.default_birb_pos(target_birb), false)
		fight.add_child(p)
	
	if helpers.this_frame(0.55, elapsed, delta):
		fight.damage_birb(active_enemy, target_birb, damage)
		fight.start_screen_shake(20)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/nevermore_impact-003.wav"))
	
	return elapsed >= duration
