extends Node2D

var duration = 0.5
var elapsed = 0
var fight

var target = 0
var target_enemy

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	fight = get_parent()

func resolve(active, _target):
	elapsed = 0

	target = _target
	target_enemy = fight.random_living_enemy()

	if fight.birbs[target].effects["fortified"] == 0 or target_enemy == -1:
		elapsed = duration
		return

func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_medium-002.wav"))
		for _i in range(20):
			var p = preload("res://scenes/Particles/Particle_Smoke_Cloud.tscn").instance()
			p.init(helpers.default_birb_pos(target))
			fight.add_child(p)	
		var p = preload("res://scenes/Particles/Particle_Cannonball.tscn").instance()
		p.init(helpers.default_birb_pos(target), helpers.default_enemy_pos(target_enemy))
		fight.add_child(p)	
	if helpers.this_frame(0.45, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_short-002.wav"))
		fight.start_screen_shake(20)
		fight.damage_enemy(-1, target_enemy, fight.birbs[target].effects["fortified"])
	return elapsed >= duration
