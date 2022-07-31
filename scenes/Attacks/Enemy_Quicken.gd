extends Node

var fight

var duration = 1.1
var active_enemy
var amount

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, _amount):
	active_enemy = active
	amount = _amount
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	
	if elapsed > 0.05 and elapsed < 1.05:
		fight.enemies[active_enemy].position = Vector2(-1000, -1000)
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/quick_effect-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Quicken.tscn").instance()
		p.init(fight.enemies[active_enemy].texture, helpers.default_enemy_pos(active_enemy), true)
		fight.add_child(p)
		p = preload("res://scenes/Particles/Particle_Quicken.tscn").instance()
		p.init(fight.enemies[active_enemy].texture, helpers.default_enemy_pos(active_enemy), false)
		fight.add_child(p)
	if helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_impact-009.wav"))
		fight.enemies[active_enemy].increase_effect("quick", 1)
		fight.damage_enemy(-1, active_enemy, amount)
		fight.enemies[active_enemy].max_hp -= amount
		if fight.enemies[active_enemy].hp > fight.enemies[active_enemy].max_hp:
			fight.enemies[active_enemy].hp = fight.enemies[active_enemy].max_hp

	return elapsed >= duration
