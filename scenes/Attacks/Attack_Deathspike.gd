extends Node

var basic_attack = false
var fight

var duration = 1.3
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/deathspike_card.wav"))
		var p = preload("res://scenes/Particles/Particle_Deathspike.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb).y, true)
		fight.add_child(p)
		
	if helpers.this_frame(1.25, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_long.wav"))
		fight.start_screen_shake(20)
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		fight.birbs[target_birb].max_hp -= k
		if fight.birbs[target_birb].max_hp < 1:
			fight.birbs[target_birb].max_hp = 1
	
	return elapsed >= duration
