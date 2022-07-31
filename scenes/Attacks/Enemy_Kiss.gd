extends Node

var fight

var duration = 1.5
var active_enemy
var target_enemy
var amount

var elapsed

var path = [
	[Vector2(0, 0), 0, 0],
	[Vector2(0, 0), 0.3, 50],
	[Vector2(0, 0), 0.6, 50],
	[Vector2(0, 0), 1.5, 0]
]

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
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/hype_effect-004.wav"))
		var p = preload("res://scenes/Particles/Particle_Fangirl.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy))
		fight.add_child(p)
	
	if helpers.this_frame(1.25, elapsed, delta):
		fight.heal_enemy(target_enemy, amount)
		fight.enemies[target_enemy].increase_effect("kissed", 1)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/kiss_effect-002.wav"))
		for _i in range(3):
			var p = preload("res://scenes/Particles/Particle_Kiss_Heart.tscn").instance()
			p.init(helpers.default_enemy_pos(target_enemy) + Vector2(-25, 0))
			fight.add_child(p)
		
	fight.enemies[active_enemy].position = helpers.jump_path(path, elapsed)
	
	return elapsed >= duration
