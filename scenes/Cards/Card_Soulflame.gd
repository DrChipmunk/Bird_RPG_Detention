extends Sprite

var type = "hawk"
var target_type = "none"
var card_name = "Soulflame"
var fight

var duration = 0.6
var active_birb
var elapsed

var last_pos
var next_pos
var max_shots
var shots_so_far
var target_enemy

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	elapsed = 0
	last_pos = helpers.default_birb_pos(active_birb)
	next_pos = Vector2(rand_range(300, 400), rand_range(100, 300))
	shots_so_far = 0
	max_shots = fight.soulflame_count
	fight.soulflame_count += 1
	target_enemy = -1
	
func animate(delta):
	elapsed += delta
	var bpos
	if elapsed < 0.3:
		bpos = helpers.jump_lerp(last_pos, next_pos, elapsed / 0.3, 25)
	else:
		bpos = helpers.jump_lerp(last_pos, next_pos, (elapsed - 0.3) / 0.3, 25)
	fight.birbs[active_birb].position = helpers.birb_absolute_pos(bpos, active_birb)
	
	if helpers.this_frame(0.15, elapsed, delta):
		if target_enemy >= 0:
			fight.damage_enemy(active_birb, target_enemy, 1)
			fight.start_screen_shake(7)
			get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_impact-009.wav"))
		
		target_enemy = fight.random_living_enemy()
		if target_enemy >= 0:
			var p = preload("res://scenes/Particles/Particle_Soulflame.tscn").instance()
			p.init(bpos, helpers.default_enemy_pos(target_enemy))
			fight.add_child(p)
			shots_so_far += 1
			fight.birbs[active_birb].set_active_sprite(0.1)

	if helpers.this_frame(0.3, elapsed, delta):
		last_pos = next_pos
		if target_enemy >= 0 and shots_so_far < max_shots:
			elapsed = 0
			next_pos = Vector2(rand_range(300, 400), rand_range(100, 300))
		else:
			next_pos = helpers.default_birb_pos(active_birb)
		
	if helpers.this_frame(0.45, elapsed, delta):
		if target_enemy >= 0:
			fight.damage_enemy(active_birb, target_enemy, 1)
			fight.start_screen_shake(7)
			get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_impact-009.wav"))
		

	
	return elapsed >= duration
