extends Node

var fight

var duration = 1.1
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/duplicate_summon-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Clone_Summon.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy), fight.enemies[active_enemy].texture)
		fight.add_child(p)	
			
	if helpers.this_frame(1.05, elapsed, delta):
		fight.enemies[active_enemy].max_hp = amount
		fight.enemies[active_enemy].hp = fight.enemies[active_enemy].max_hp
		fight.enemies[active_enemy].visible = true

	return elapsed >= duration
