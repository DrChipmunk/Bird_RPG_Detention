extends Node2D

var duration = 0.5
var elapsed = 0
var fight

var affect_enemy = false
var target = 0

var helpers = preload("res://scenes/Helpers.gd")

var fire_sounds = [preload("res://sounds/fire_tick.wav"),
preload("res://sounds/fire_tick-002.wav"),
preload("res://sounds/fire_tick-001.wav")]

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
	if character().effects["aflame"] <= 0:
		elapsed = duration
		return
	get_node("Sound_Effect_Player").load_and_play(helpers.rand_choice(fire_sounds))
	if affect_enemy:
		fight.damage_enemy(-1, target, character().effects["aflame"])
	else:
		fight.damage_birb(-1, target, character().effects["aflame"])
	for _i in range(character().effects["aflame"] * 3):
		var p = preload("res://scenes/Particles/Particle_Flame.tscn").instance()
		p.init(character_pos())
		fight.add_child(p)	
	character().effects["aflame"] -= 1

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
	return elapsed >= duration
