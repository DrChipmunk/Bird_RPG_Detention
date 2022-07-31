extends Sprite

var type = "swan"
var target_type = "none"
var card_name = "Blood Rite"
var fight

var duration = 1
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
	var start_pos = Vector2(0, 0)

	if helpers.this_frame(0.05, elapsed, delta):
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Blood_Drop_1.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), false)
		fight.add_child(p)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
		
	if helpers.this_frame(0.5, elapsed, delta):
		fight.damage_birb(-1, active_birb, 2)
		for i in range(4):
			if active_birb != i:
				fight.heal_birb(i, 2)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/blood_rite_card-004.wav"))
	
	return elapsed >= duration
