extends Sprite

var type = "hawk_swan"
var target_type = "none"
var card_name = "Headcrack"
var fight

var duration = 1
var active_birb
var target_enemy_1
var target_enemy_2
var elapsed

var path_1
var path_2

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_enemy_1 = fight.random_living_enemy()
	target_enemy_2 = fight.other_random_living_enemy(target_enemy_1)	
	elapsed = 0
	var k = rand_range(-100, 100)
	path_1 = [
		[Vector2(0, 0), 0, 0],
		[helpers.enemy_absolute_pos(Vector2(400 + k, 0), target_enemy_1), 0.85, 0],
		[helpers.enemy_absolute_pos(Vector2(400, 200), target_enemy_1), 0.91, 0],
		[Vector2(0, 0), 1, 60]
	]
	path_2 = [
		[Vector2(0, 0), 0, 0],
		[helpers.enemy_absolute_pos(Vector2(400 - k, 400), target_enemy_2), 0.85, 0],
		[helpers.enemy_absolute_pos(Vector2(400, 200), target_enemy_2), 0.91, 0],
		[Vector2(0, 0), 1, 60]
	]
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
		
	if target_enemy_1 >= 0:
		fight.enemies[target_enemy_1].position = helpers.jump_path(path_1, 1 - (1 - progress) * (1 - progress))
	if target_enemy_2 >= 0:
		fight.enemies[target_enemy_2].position = helpers.jump_path(path_2, 1 - (1 - progress) * (1 - progress))		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
	if helpers.this_frame(0.7, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_impact_hard-003.wav"))
		fight.start_screen_shake(40)
		for i in range(20):
			var p = preload("res://scenes/Particles/Particle_Smoke_Cloud.tscn").instance()
			p.init(Vector2(400, 200))
			fight.add_child(p)		
		if target_enemy_1 >= 0:
			fight.enemies[target_enemy_1].increase_effect("shattered", 1)
		if target_enemy_2 >= 0:
			fight.enemies[target_enemy_2].increase_effect("shattered", 1)		
	
	return elapsed >= duration
