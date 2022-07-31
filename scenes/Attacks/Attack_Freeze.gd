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
	var progress = elapsed / duration
	
	var a = 20 - 80 * (progress - 0.5) * (progress - 0.5)
	fight.birbs[target_birb].position = Vector2(a * sin(progress * 25), 0)
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/freeze_card-003.wav"))
		
	if helpers.n_times_per_second(150, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Freeze.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb))
		fight.add_child(p)

	if helpers.this_frame(0.9, elapsed, delta):
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		fight.birbs[target_birb].increase_effect("frozen_delayed", k)
	
	return elapsed >= duration
