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
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/plasma_effect-002.wav"))
		var p = preload("res://scenes/Particles/Particle_Plasma.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy), helpers.default_birb_pos(target_birb))
		fight.add_child(p)
	
	if helpers.this_frame(0.95, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/confusion_impact-013.wav"))
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		fight.birbs[target_birb].increase_effect("confused", k)
		fight.start_screen_shake(10)
	
	return elapsed >= duration
