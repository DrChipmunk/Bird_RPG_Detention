extends Node

var basic_attack = false
var fight

var duration = 1
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
	var progress = elapsed / delta
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/fire_start-008.wav"))
		
	if helpers.this_frame(0.1, elapsed, delta):
		for _i in range(40):
			var p = preload("res://scenes/Particles/Particle_Fireball.tscn").instance()
			p.init(helpers.default_enemy_pos(active_enemy), helpers.default_birb_pos(target_birb))
			fight.add_child(p)
	
	if helpers.this_frame(0.9, elapsed, delta):
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		fight.birbs[target_birb].increase_effect("aflame", k)
		for _i in range(60):
			var p = preload("res://scenes/Particles/Particle_Flame.tscn").instance()
			p.init(helpers.default_birb_pos(target_birb))
			fight.add_child(p)			
	
	return elapsed >= duration
