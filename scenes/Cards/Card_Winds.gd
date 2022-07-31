extends Sprite

var type = "peacock"
var target_type = "birb"
var card_name = "Winds"
var fight

var duration = 1.1
var active_birb
var target_birb
var elapsed 

var helpers = preload("res://scenes/Helpers.gd")

var pos1
var pos3

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_birb = target
	elapsed = 0
	particle_timer = 0
	pos1 = helpers.default_birb_pos(target_birb) + Vector2(-200, rand_range(-50, 50))
	pos3 = helpers.default_birb_pos(target_birb) + Vector2(400, rand_range(-50, 50))
	
	
var particle_timer
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	if helpers.n_times_per_second(40, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Winds.tscn").instance()
		p.init(pos1, helpers.default_birb_pos(target_birb), pos3)
		get_parent().add_child(p)
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/winds_card-003.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
	
	if helpers.this_frame(0.7, elapsed, delta):
		fight.birbs[target_birb].increase_effect("prepared", 2)
		
	
	return elapsed >= duration
