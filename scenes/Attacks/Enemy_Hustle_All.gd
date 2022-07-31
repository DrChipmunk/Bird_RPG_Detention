extends Node

var fight

var duration = 1
var active_enemy

var path1
var path2

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
		[Vector2(0, 0), 0.66, 40],
		[Vector2(0, 0), 1, 0],
	]
	
	path2 = [
		[Vector2(0, 0), 0, 0],
		[Vector2(0, 0), 0.34, 0],
		[Vector2(20, 0), 0.56, 40],
		[Vector2(-20, 0), 0.78, 40],
		[Vector2(0, 0), 1, 40],
	]
	
func animate(delta):
	elapsed += delta
	
	for i in range(4):
		if i == active_enemy:
			fight.enemies[i].position = helpers.jump_path(path1, elapsed)
		else:
			fight.enemies[i].position = helpers.jump_path(path2, elapsed)
	
	if helpers.this_frame(0.33, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/hustle_card-005.wav"))
		var p = preload("res://scenes/Particles/Particle_Hustle.tscn").instance()
		p.init(helpers.default_enemy_pos(active_enemy))
		fight.add_child(p)
	
	if helpers.this_frame(0.45, elapsed, delta):
		for i in range(4):
			if i != active_enemy and fight.enemies[i].hp > 0:		
				fight.enemies[i].increase_effect("hustle", 1)
				var p = preload("res://scenes/Particles/Particle_Hustle.tscn").instance()
				p.init(helpers.default_enemy_pos(i))
				fight.add_child(p)
	
	return elapsed >= duration
