extends Node2D

var duration = 0.5
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
	if character().effects["regenerating"] == 0:
		elapsed = duration
		return
	get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/radiance_effect-001.wav"))
	if affect_enemy:
		fight.heal_enemy(target, 1)
	else:
		fight.heal_birb(target, 1)
	for _i in range(3):
		var p = preload("res://scenes/Particles/Particle_Radiance_Trail.tscn").instance()
		p.init(character_pos())
		fight.add_child(p)	
	character().effects["regenerating"] -= 1

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
