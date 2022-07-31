extends Sprite

var type = "any"
var target_type = "none"
var card_name = "Guard"
var fight

var duration = 0.3
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/guard_v2-002.wav"))
		
	if helpers.this_frame(0.15, elapsed, delta):
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Guard.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb) + Vector2(20, 0), false)
		fight.add_child(p)
		fight.birbs[active_birb].increase_effect("defence", 3)

	
	return elapsed >= duration
