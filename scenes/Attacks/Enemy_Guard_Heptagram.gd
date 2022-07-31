extends Node

var fight

var duration = 1.2
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/heptagram_effect-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Heptagram.tscn").instance()
		p.init(Vector2(500, 100), Vector2(50, 0), Vector2(0, 100), preload("res://sprites/heptagram_star_blue.png"))
		fight.add_child(p)	
			
	if helpers.this_frame(1.1, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/guard_v2-002.wav"))
		for i in range(4):
			if fight.enemies[i].hp > 0:
				fight.enemies[i].increase_effect("defence", amount)
				


	return elapsed >= duration
