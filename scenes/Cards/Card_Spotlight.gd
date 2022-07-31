extends Sprite

var type = "finch"
var target_type = "birb"
var card_name = "Spotlight"
var fight

var duration = 1.6
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
	particle_timer = 0
	
var particle_timer
	
func animate(delta):
	elapsed += delta
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/spotlight_card-003.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		for _i in range(3):
			var p = preload("res://scenes/Particles/Particle_Spotlight.tscn").instance()
			p.init(helpers.default_birb_pos(target_birb))
			fight.add_child(p)
	
	if helpers.this_frame(1.55, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_medium-002.wav"))
		fight.birbs[target_birb].increase_effect("immune_imminent", 1)
	
	return elapsed >= duration
