extends Node

var basic_attack = false
var fight

var duration = 0.5
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
	var progress = elapsed / duration
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_medium-002.wav"))
		for _i in range(20):
			var p = preload("res://scenes/Particles/Particle_Smoke_Cloud.tscn").instance()
			p.init(helpers.default_enemy_pos(active_enemy))
			fight.add_child(p)	
		var p = preload("res://scenes/Particles/Particle_Cannonball.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy), helpers.default_birb_pos(target_birb))
		fight.add_child(p)	
	if helpers.this_frame(0.45, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_short-002.wav"))
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		if k > 0:
			fight.birbs[target_birb].increase_effect("stun", 1)	
	
	return elapsed >= duration
