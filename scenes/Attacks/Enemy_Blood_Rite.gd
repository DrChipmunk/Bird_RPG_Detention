extends Node

var fight

var duration = 0.6
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
	
	if helpers.this_frame(0.05, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Blood_Drop_1.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy), true)
		fight.add_child(p)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
		
	if helpers.this_frame(0.5, elapsed, delta):
		fight.damage_enemy(-1, active_enemy, 2)
		for i in range(4):
			if active_enemy != i:
				fight.heal_enemy(i, amount)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/blood_rite_card-004.wav"))

	return elapsed >= duration
