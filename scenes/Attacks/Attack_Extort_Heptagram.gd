extends Node

var basic_attack = false
var fight

var duration = 1.2
var active_enemy
var target_birb
var damage

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

var sprites = [
	preload("res://sprites/bone_particle_1.png"), 
	preload("res://sprites/bone_particle_2.png"), 
	preload("res://sprites/bone_particle_3.png"), 
	preload("res://sprites/bone_particle_4.png"), 
	preload("res://sprites/bone_particle_5.png"), 
	preload("res://sprites/bone_particle_6.png"), 
	preload("res://sprites/bone_particle_7.png"), 
	preload("res://sprites/bone_particle_8.png"), 
	preload("res://sprites/bone_particle_9.png"), 
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/heptagram_effect-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Heptagram.tscn").instance()
		var pos = (helpers.default_birb_pos(target_birb) + helpers.default_enemy_pos(active_enemy)) / 2
		var vec1 = (helpers.default_birb_pos(target_birb) - helpers.default_enemy_pos(active_enemy)) * 0.2
		var vec2 = vec1.rotated(PI / 2) * 3
		p.init(pos, vec1, vec2, preload("res://sprites/heptagram_star_purple.png"))
		fight.add_child(p)	
			
	if helpers.n_times_per_second(25, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Drain.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb), helpers.default_enemy_pos(active_enemy))
		p.texture = helpers.rand_choice(sprites)
		fight.add_child(p)
		
	if helpers.n_times_per_second(4, elapsed, delta):
		fight.start_screen_shake(7)
		
	if helpers.this_frame(0.75, elapsed, delta):
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		fight.heal_enemy(active_enemy, k)
	
	return elapsed >= duration
