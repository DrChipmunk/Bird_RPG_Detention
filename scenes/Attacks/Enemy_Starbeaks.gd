extends Node

var fight

var duration = 0.4
var active_enemy
var amount

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, _amount):
	active_enemy = active
	amount = _amount
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/self_care_card-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Starbeaks.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy))
		get_parent().add_child(p)
		fight.heal_enemy(active_enemy, amount)
	
	return elapsed >= duration
