extends Sprite

var type = "any"
var target_type = "none"
var card_name = "Curse"
var fight
var consumable = true

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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/cringe_card-005.wav"))
		fight.birbs[active_birb].set_active_sprite(0.1)
		for _i in range(3):
			var p = preload("res://scenes/Particles/Particle_Dinocurse.tscn").instance()
			p.init(helpers.default_birb_pos(active_birb) + helpers.rand_in_circle(200))
			fight.add_child(p)
		fight.start_screen_shake(5)
		fight.damage_birb(-1, active_birb, 1)

		
	
	return elapsed >= duration
