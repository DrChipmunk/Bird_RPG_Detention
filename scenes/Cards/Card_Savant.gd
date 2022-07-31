extends Sprite

var type = "hawk_peacock"
var target_type = "none"
var card_name = "Savant"
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
		fight.birbs[active_birb].set_active_sprite(0.3)

		var p = preload("res://scenes/Particles/Particle_Improvise.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), rand_range(-PI, PI))
		get_parent().add_child(p)
		p = preload("res://scenes/Particles/Particle_Radiance_Trail.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb))
		get_parent().add_child(p)		
		p = preload("res://scenes/Particles/Particle_Thorns_Trail.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb))
		get_parent().add_child(p)		
		p = preload("res://scenes/Particles/Particle_Kneecap.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), helpers.default_birb_pos(active_birb) + helpers.rand_in_circle(200))
		get_parent().add_child(p)		
		p = preload("res://scenes/Particles/Particle_Quake.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), helpers.default_birb_pos(active_birb) + helpers.rand_in_circle(200))
		get_parent().add_child(p)	
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Play_Rand_Card.tscn"), -1)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Play_Rand_Card.tscn"), -1)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/smoke_fade-003.wav"))
	
	return elapsed >= duration
