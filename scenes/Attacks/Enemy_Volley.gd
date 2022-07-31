extends Node

var fight

var duration = 0.6
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
		
	if elapsed < 0.5:
		var progress = elapsed / 0.5
		fight.enemies[active_enemy].position = helpers.jump_lerp(Vector2(0, 0), Vector2(0, 0), progress, -50)
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
		
	if helpers.this_frame(0.5, elapsed, delta):
		fight.birbs[target_birb].increase_effect("volley", amount)
		var p = preload("res://scenes/Particles/Particle_Volley_Up.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy), true)
		fight.add_child(p)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/volley_up-005.wav"))		
	
	return elapsed >= duration
