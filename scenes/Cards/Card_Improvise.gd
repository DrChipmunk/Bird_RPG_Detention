extends Sprite

var type = "finch"
var target_type = "none"
var card_name = "Improvise"
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
		for _i in range(30):
			var p = preload("res://scenes/Particles/Particle_Improvise.tscn").instance()
			p.init(helpers.default_birb_pos(active_birb), rand_range(-PI, PI))
			get_parent().add_child(p)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/improvise_card-009.wav"))
	
	return elapsed >= duration
