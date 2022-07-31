extends Node

var fight

var duration = 1.6
var active_enemy
var self_guard
var others_guard

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, _self_guard, _others_guard):
	active_enemy = active
	self_guard = _self_guard
	others_guard = _others_guard
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/spotlight_card-003.wav"))
		for _i in range(3):
			var p = preload("res://scenes/Particles/Particle_Spotlight.tscn").instance()
			p.init(helpers.default_enemy_pos(active_enemy))
			fight.add_child(p)
	if helpers.this_frame(1.55, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_medium-002.wav"))
		fight.ai_peep_bottom(active_enemy)
		for i in range(4):
			if fight.enemies[i].hp > 0:
				if i == active_enemy:
					fight.enemies[i].increase_effect("defence", self_guard)
				else:
					fight.enemies[i].increase_effect("defence", others_guard)
			var p = preload("res://scenes/Particles/Particle_Guard.tscn").instance()
			p.init(helpers.default_enemy_pos(i) + Vector2(-20, 0), true)
			fight.add_child(p)
	return elapsed >= duration
