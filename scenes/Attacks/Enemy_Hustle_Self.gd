extends Node

var fight

var duration = 0.66
var active_enemy

var path1

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active):
	active_enemy = active
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
	path1 = [
		[Vector2(0, 0), 0, 0],
		[Vector2(20, 0), 0.22, 40],
		[Vector2(-20, 0), 0.44, 40],
		[Vector2(0, 0), 0.66, 40]
	]
	
func animate(delta):
	elapsed += delta
	
	fight.enemies[active_enemy].position = helpers.jump_path(path1, elapsed)
	
	if helpers.this_frame(0.33, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/hustle_card-005.wav"))
		var p = preload("res://scenes/Particles/Particle_Hustle.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy))
		fight.add_child(p)
	
	if helpers.this_frame(0.45, elapsed, delta):
		fight.enemies[active_enemy].increase_effect("hustle", 1)
	
	return elapsed >= duration
