extends Node

var basic_attack = false
var fight

var duration = 0.5
var active_enemy
var target_birb
var damage

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

var sounds = [
	preload("res://sounds/coo-002.wav"),
	preload("res://sounds/coo-008.wav"),
	preload("res://sounds/coo-010.wav"),
	preload("res://sounds/coo-013.wav"),
	preload("res://sounds/coo-014.wav")
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
		get_node("Sound_Effect_Player").load_and_play(helpers.rand_choice(sounds))
		for _i in range(4):
			var p = preload("res://scenes/Particles/Particle_Coo.tscn").instance()
			p.init(helpers.default_enemy_pos(active_enemy), helpers.default_birb_pos(target_birb))
			fight.add_child(p)
	
	if helpers.this_frame(0.45, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/confusion_impact-013.wav"))
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		fight.birbs[target_birb].increase_effect("confused", k)
		fight.start_screen_shake(10)
	
	return elapsed >= duration
