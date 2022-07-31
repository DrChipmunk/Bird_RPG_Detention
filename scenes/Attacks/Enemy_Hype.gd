extends Node

var fight

var duration = 0.3
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/hype_effect-004.wav"))
		for _i in range(40):
			var p = preload("res://scenes/Particles/Particle_Confetti.tscn").instance()
			p.init(helpers.default_enemy_pos(active_enemy) + Vector2(0, 40))
			fight.add_child(p)
		fight.enemies[active_enemy].increase_effect("hype", amount)

	return elapsed >= duration
