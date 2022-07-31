extends Sprite

var type = "hawk"
var target_type = "none"
var card_name = "Swipe"
var fight

var duration = 1.1
var active_birb
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	var path = [
		[Vector2(0, 0), 0, 0],
		[helpers.birb_absolute_pos(Vector2(530, 30), active_birb), 0.45, 50],
		[helpers.birb_absolute_pos(Vector2(530, 320), active_birb), 0.6, 0],
		[Vector2(0, 0), 1.1, 50]
	]
	fight.birbs[active_birb].position = helpers.jump_path(path, elapsed)
	
	if helpers.this_frame(0.5, elapsed, delta):
		fight.start_screen_shake(20)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/swipe_card-005.wav"))
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
	
	if helpers.this_frame(0.45, elapsed, delta):
		fight.damage_enemy(active_birb, 0, 3)
	if helpers.this_frame(0.5, elapsed, delta):
		fight.damage_enemy(active_birb, 1, 3)
	if helpers.this_frame(0.55, elapsed, delta):
		fight.damage_enemy(active_birb, 2, 3)
	if helpers.this_frame(0.6, elapsed, delta):
		fight.damage_enemy(active_birb, 3, 3)
		

	
	return elapsed >= duration
