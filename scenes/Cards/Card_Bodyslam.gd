extends Sprite

var type = "hawk"
var target_type = "enemy"
var card_name = "Bodyslam"
var fight

var duration = 1.6
var active_birb
var target_enemy
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_enemy = target
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	var birb_pos1 = helpers.birb_absolute_pos(helpers.default_enemy_pos(target_enemy) + Vector2(-10, 0), active_birb)
	var birb_pos2 = helpers.birb_absolute_pos(Vector2(390, 200), active_birb)
	var enemy_pos = helpers.enemy_absolute_pos(Vector2(410, 200), target_enemy)
	
	if elapsed < 0.4:
		var progress = elapsed / 0.4
		fight.birbs[active_birb].position = helpers.jump_lerp(Vector2(0, 0), birb_pos1, progress, 50)
	elif elapsed < 1.2:
		var progress = (elapsed - 0.4) / 0.8
		fight.birbs[active_birb].position = helpers.jump_lerp(birb_pos1, birb_pos2, progress, 800)
		fight.enemies[target_enemy].position = helpers.jump_lerp(Vector2(0, 0), enemy_pos, progress, 800)
	else:
		var progress = (elapsed - 1.2) / 0.4
		fight.birbs[active_birb].position = helpers.jump_lerp(birb_pos2, Vector2(0, 0), progress, 50)
		fight.enemies[target_enemy].position = helpers.jump_lerp(enemy_pos, Vector2(0, 0), progress, 50)
	
	if helpers.this_frame(0.4, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
		
	if helpers.this_frame(1.2, elapsed, delta):
		fight.damage_enemy(active_birb, target_enemy, 13)
		fight.birbs[active_birb].increase_effect("stun", 1)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/bodyslam_card-001.wav"))
		fight.start_screen_shake(50)
		for i in range(40):
			var p = preload("res://scenes/Particles/Particle_Smoke_Cloud.tscn").instance()
			p.init(Vector2(400, 200))
			fight.add_child(p)
	
	return elapsed >= duration
