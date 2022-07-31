extends Sprite

var type = "any"
var target_type = "none"
var card_name = "Dinocurse"
var fight
var consumable = true

var duration = 0.5
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/dinocurse_effect-001.wav"))
		fight.birbs[active_birb].set_active_sprite(0.1)

	if helpers.this_frame(0.45, elapsed, delta):
		for i in range(4):
			fight.damage_birb(-1, i, 1)
			fight.damage_enemy(-1, i, 1)

	if helpers.n_times_per_second(13, elapsed, delta):
		for _i in range(10):
			var p = preload("res://scenes/Particles/Particle_Dinocurse.tscn").instance()
			p.init(helpers.default_birb_pos(active_birb) + helpers.rand_in_circle(200))
			fight.add_child(p)
		fight.start_screen_shake(5)
		
	
	return elapsed >= duration
