extends Node

var basic_attack = true
var fight

var duration = 1.5
var active_enemy
var target_birb
var damage

var elapsed

var sprites = [
	preload("res://sprites/fangirl_1_idle.png"), 
	preload("res://sprites/fangirl_2_idle.png"), 
	preload("res://sprites/fangirl_3_idle.png"), 
	preload("res://sprites/fangirl_4_idle.png"), 
	preload("res://sprites/fangirl_5_idle.png"), 
	preload("res://sprites/fangirl_6_idle.png"), 
	preload("res://sprites/fangirl_7_idle.png"), 
	preload("res://sprites/fangirl_8_idle.png"), 
	preload("res://sprites/fangirl_9_idle.png"), 
	preload("res://sprites/duck_idle.png"), 
]

var new_enemy
var path

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, target, amount):
	active_enemy = active
	target_birb = target
	damage = amount
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	new_enemy = 0
	for i in range(4):
		if fight.enemies[i].hp == 0:
			new_enemy = i
	fight.enemies[new_enemy].hp = 7
	fight.enemies[new_enemy].max_hp = 7
	fight.enemies[new_enemy].texture = helpers.rand_choice(sprites)
	fight.enemies[new_enemy].visible = true
	path = [
		[helpers.enemy_absolute_pos(helpers.default_enemy_pos(active_enemy), new_enemy), 0, 0],
		[helpers.enemy_absolute_pos(Vector2(400, 200), new_enemy), 0.5, 50],
		[helpers.enemy_absolute_pos(helpers.default_birb_pos(target_birb), new_enemy), 1, 50],
		[Vector2(0, 0), 1.5, 50],		
	]
	
func animate(delta):
	elapsed += delta
	
	fight.enemies[new_enemy].position = helpers.jump_path(path, elapsed)
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
	
	if helpers.this_frame(1, elapsed, delta):
		fight.damage_birb(active_enemy, target_birb, damage)
		fight.start_screen_shake(20)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/peck_card-003.wav"))
	
	return elapsed >= duration
