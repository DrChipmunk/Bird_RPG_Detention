extends Sprite

var type = "any"
var target_type = "birb"
var card_name = "Assist"
var fight

var duration = 1
var active_birb
var target_birb
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_birb = target
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	
	if elapsed < 0.5:
		var progress = elapsed / 0.5
		fight.birbs[active_birb].position = helpers.jump_lerp(Vector2(0, 0), Vector2(0, 0), progress, 50)
	else:
		var progress = (elapsed - 0.5) / 0.5
		fight.birbs[target_birb].position = helpers.jump_lerp(Vector2(0, 0), Vector2(0, 0), progress, 50)
	
	if helpers.this_frame(0.15, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/assist_card-003.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
	
	if helpers.this_frame(0.65, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/assist_card-003.wav"))
		fight.birbs[target_birb].give_action()
	
	return elapsed >= duration
