extends Node

var fight

var duration = 1.2
var active_enemy
var target_birb
var amount

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, target, _amount):
	active_enemy = active
	amount = _amount
	target_birb = target
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/heptagram_effect-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Heptagram.tscn").instance()
		p.init(Vector2(600, 250), Vector2(150, -50), Vector2(25, 75), preload("res://sprites/heptagram_star_yellow.png"))
		fight.add_child(p)	
			
	if helpers.this_frame(1.1, elapsed, delta):
		fight.birbs[target_birb].increase_effect("volley", amount)
		var p = preload("res://scenes/Particles/Particle_Volley_Up.tscn").instance()
		p.init(Vector2(600, 250), true)
		fight.add_child(p)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/volley_up-005.wav"))
				


	return elapsed >= duration
