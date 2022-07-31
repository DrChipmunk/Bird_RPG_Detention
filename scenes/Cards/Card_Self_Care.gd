extends Sprite

var type = "peacock_swan"
var target_type = "none"
var card_name = "Self Care"
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
	
	
var particle_timer
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	if helpers.n_times_per_second(20, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Self_Care.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb))
		get_parent().add_child(p)
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/self_care_card-001.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
	
	if helpers.this_frame(0.7, elapsed, delta):
		fight.heal_birb(active_birb, 2)
		fight.birbs[active_birb].increase_effect("prepared", 1)
		
	
	return elapsed >= duration
