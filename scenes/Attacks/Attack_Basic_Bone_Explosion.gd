extends Node

var basic_attack = true
var fight

var duration = 1.7
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
	
	fight.enemies[active_enemy].position = Vector2(-1000, -1000)
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/smoke_fade-003.wav"))
		for _i in range(150):
			var p = preload("res://scenes/Particles/Particle_Bone_Explosion.tscn").instance()
			p.init(helpers.default_enemy_pos(active_enemy), helpers.default_birb_pos(target_birb))
			fight.add_child(p)
	
	if helpers.this_frame(1.65, elapsed, delta):
		fight.damage_birb(active_enemy, target_birb, damage)
		fight.start_screen_shake(40)
		fight.damage_enemy(-1, active_enemy, 99)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/nevermore_impact-003.wav"))
	
	return elapsed >= duration
