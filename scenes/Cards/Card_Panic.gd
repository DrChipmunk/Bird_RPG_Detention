extends Sprite

var type = "any"
var target_type = "none"
var card_name = "Panic"
var fight

var duration = 0.1
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
		
	if helpers.this_frame(0.05, elapsed, delta):
		fight.start_screen_shake(15)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/panic_card-003.wav"))
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Play_First_Card.tscn"), -1)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)		
		
	if helpers.n_times_per_second(100, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Droplet.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb))
		fight.add_child(p)
		

	
	return elapsed >= duration
