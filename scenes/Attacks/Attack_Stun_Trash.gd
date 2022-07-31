extends Node

var basic_attack = false
var fight

var duration = 1.1
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
		var p = preload("res://scenes/Particles/Particle_Trash_Ball.tscn").instance()
		p.init(Vector2(rand_range(300, 600), 700), helpers.default_birb_pos(target_birb))
		fight.add_child(p)	
	if helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/trash_short-009.wav"))
		fight.start_screen_shake(35)
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		if k > 0:
			fight.birbs[target_birb].increase_effect("stun", 1)	
	
	return elapsed >= duration
