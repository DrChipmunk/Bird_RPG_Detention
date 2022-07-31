extends Node

var fight

var duration = 2
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
	
	var path = [
	[helpers.enemy_absolute_pos(Vector2(400,200), active_enemy), 0, 0],
	[helpers.enemy_absolute_pos(Vector2(400,200), active_enemy), 1.2, 0],
	[Vector2(0, 0), 2, 50]
	]
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/heptagram_effect-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Heptagram.tscn").instance()
		p.init(Vector2(400, 200), Vector2(180, 0), Vector2(0, 180), preload("res://sprites/heptagram_star.png"))
		fight.add_child(p)	
		p = preload("res://scenes/Particles/Particle_Bone_Summon.tscn").instance()
		p.init()
		fight.add_child(p)	
			
	if helpers.this_frame(1.05, elapsed, delta):
		fight.enemies[active_enemy].max_hp = amount
		fight.enemies[active_enemy].hp = fight.enemies[active_enemy].max_hp
		fight.enemies[active_enemy].add_bone_sprites()
		fight.enemies[active_enemy].visible = true
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_medium-002.wav"))
				
	fight.enemies[active_enemy].position = helpers.jump_path(path, elapsed)

	return elapsed >= duration
