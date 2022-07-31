extends Sprite

var type = "hawk_peacock"
var target_type = "none"
var card_name = "Focus"
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
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/focus_card-003.wav"))
		var p = preload("res://scenes/Particles/Particle_Focus.tscn").instance()
		p.init(active_birb, helpers.default_birb_pos(active_birb))
		fight.add_child(p)
		
	if helpers.this_frame(0.95, elapsed, delta):
		fight.birbs[active_birb].increase_effect("hustle_delayed", 1)
	fight.birbs[active_birb].position = Vector2(-1000, -1000)
	
	return elapsed >= duration
