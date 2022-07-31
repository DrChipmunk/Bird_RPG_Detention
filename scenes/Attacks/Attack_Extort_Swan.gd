extends Node

var basic_attack = false
var fight

var duration = 0.8
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/drain_card-008.wav"))
			
	if helpers.n_times_per_second(25, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Drain.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb), helpers.default_enemy_pos(active_enemy))
		fight.add_child(p)
		
	if helpers.n_times_per_second(4, elapsed, delta):
		fight.start_screen_shake(7)
		
	if helpers.this_frame(0.75, elapsed, delta):
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		fight.heal_enemy(active_enemy, k)
	
	return elapsed >= duration
