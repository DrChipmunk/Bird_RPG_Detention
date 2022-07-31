extends Node

var fight

var duration = 1.4
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
	
	var path = [
		[Vector2(0, 0), 0, 0],
		[helpers.enemy_absolute_pos(helpers.default_enemy_pos(target_enemy), active_enemy) + Vector2(-70, 0), 0.4, 50],
		[helpers.enemy_absolute_pos(helpers.default_enemy_pos(target_enemy), active_enemy) + Vector2(-70, 0), 1.0, 0],
		[Vector2(0, 0), 1.4, 50]
	]
	fight.enemies[active_enemy].position = helpers.jump_path(path, elapsed)
	
	if helpers.this_frame(0.5, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/guard_v2-002.wav"))
		fight.enemies[target_enemy].increase_effect("defence", amount)
		var p = preload("res://scenes/Particles/Particle_Guard.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy) + Vector2(-90, 0), true)
		fight.add_child(p)
	
	if helpers.this_frame(0.05, elapsed, delta) or helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
	
	return elapsed >= duration
