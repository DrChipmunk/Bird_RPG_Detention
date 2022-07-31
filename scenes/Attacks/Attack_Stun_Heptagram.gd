extends Node

var basic_attack = false
var fight

var duration = 1.6
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/heptagram_effect-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Heptagram.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb), Vector2(70, 0), Vector2(0, 70), preload("res://sprites/heptagram_star_green.png"))
		fight.add_child(p)	

	if helpers.this_frame(1.55, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_impact_hard-003.wav"))
		fight.start_screen_shake(30)
		
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		if k > 0:
			fight.birbs[target_birb].increase_effect("stun", 1)
	
	return elapsed >= duration
