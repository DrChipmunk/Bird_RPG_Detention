extends Node2D

var duration = 0.9
var elapsed = 0
var fight

var affect_enemy = false
var target = 0

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	fight = get_parent()

func resolve(active, _target):
	elapsed = 0
	if _target < 4:
		affect_enemy = false
		target = _target
	else:
		affect_enemy = true
		target = _target - 4
	if character().effects["volley_imminent"] == 0:
		character().effects["volley_imminent"] = character().effects["volley"]
		character().effects["volley"] = 0
		elapsed = duration
		return

func character():
	if affect_enemy:
		return fight.enemies[target]
	else:
		return fight.birbs[target]
		
func character_pos():
	if affect_enemy:
		return helpers.default_enemy_pos(target)
	else:
		return helpers.default_birb_pos(target)

func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/volley_down-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Volley_Down.tscn").instance()
		p.init(character_pos(), affect_enemy)
		fight.add_child(p)	
	if helpers.this_frame(0.85, elapsed, delta):
		if affect_enemy:
			fight.damage_enemy(-1, target, character().effects["volley_imminent"])
		else:
			fight.damage_birb(-1, target, character().effects["volley_imminent"])
		fight.start_screen_shake(character().effects["volley_imminent"] * 5)
		character().effects["volley_imminent"] = character().effects["volley"]
		character().effects["volley"] = 0
		for _i in range(20):
			var p = preload("res://scenes/Particles/Particle_Smoke_Cloud.tscn").instance()
			p.init(character_pos())
			fight.add_child(p)	
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_medium-002.wav"))
	return elapsed >= duration
