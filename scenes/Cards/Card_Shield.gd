extends Sprite

var type = "finch"
var target_type = "birb"
var card_name = "Shield"
var fight

var duration = 1.4
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
	
	var path = [
		[Vector2(0, 0), 0, 0],
		[helpers.birb_absolute_pos(helpers.default_birb_pos(target_birb), active_birb) + Vector2(70, 0), 0.4, 50],
		[helpers.birb_absolute_pos(helpers.default_birb_pos(target_birb), active_birb) + Vector2(70, 0), 1.0, 0],
		[Vector2(0, 0), 1.4, 50]
	]
	fight.birbs[active_birb].position = helpers.jump_path(path, elapsed)
	
	if helpers.this_frame(0.5, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/guard_v2-002.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		fight.birbs[target_birb].increase_effect("defence", 5)
		var p = preload("res://scenes/Particles/Particle_Guard.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb) + Vector2(90, 0), false)
		fight.add_child(p)
	
	if helpers.this_frame(0.05, elapsed, delta) or helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
	
	return elapsed >= duration
