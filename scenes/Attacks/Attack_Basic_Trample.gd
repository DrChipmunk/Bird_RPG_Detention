extends Node

var basic_attack = true
var fight

var duration = 1.5
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/trample_attack.wav"))
		
	if helpers.n_times_per_second(11, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Trample.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb))
		fight.add_child(p)
	
	if helpers.this_frame(1.45, elapsed, delta):
		fight.damage_birb(active_enemy, target_birb, damage)
		fight.start_screen_shake(20)
	
	return elapsed >= duration
