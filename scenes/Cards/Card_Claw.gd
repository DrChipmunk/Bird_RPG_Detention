extends Sprite

var type = "hawk"
var target_type = "enemy"
var card_name = "Claw"
var fight

var duration = 1.3
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
	var epos = helpers.birb_absolute_pos(helpers.default_enemy_pos(target_enemy), active_birb)
	var path = [
		[Vector2(0, 0), 0, 0],
		[epos + Vector2(-10, 30), 0.5, 50],
		[epos + Vector2(0, -30), 0.55, 0],
		[epos + Vector2(10, 30), 0.6, 0],
		[epos + Vector2(30, 0), 0.65, 0],
		[epos + Vector2(-200, 0), 0.8, 0],
		[Vector2(0, 0), 1.3, 50]
	]
	fight.birbs[active_birb].position = helpers.jump_path(path, elapsed)
	
	if helpers.this_frame(0.5, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/swipe_card-011.wav"))
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
	
	if helpers.this_frame(0.7, elapsed, delta):
		fight.damage_enemy(active_birb, target_enemy, 8)
		fight.start_screen_shake(30)
		fight.enemies[target_enemy].change_attacks()
		

	
	return elapsed >= duration
