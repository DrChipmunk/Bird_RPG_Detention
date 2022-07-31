extends Node

var fight

var duration = 1.6
var active_enemy
var target_enemy
var amount

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, target, _amount):
	active_enemy = active
	amount = _amount
	target_enemy = target
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	if helpers.n_times_per_second(20, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Mist_Wisp.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy))
		get_parent().add_child(p)
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/mists_card-003.wav"))
	
	if helpers.this_frame(0.5, elapsed, delta):
		fight.heal_enemy(target_enemy, amount)
		
	fight.enemies[target_enemy].position = Vector2(-20 * sin(progress * PI * 2), 0)
	
	return elapsed >= duration
