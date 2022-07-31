extends Sprite

var type = "hawk"
var target_type = "none"
var card_name = "Gains"
var fight

var duration = 1.2
var active_birb
var elapsed

var path

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	elapsed = 0
	path = [
		[Vector2(0, 0), 0, 0],
		[helpers.birb_absolute_pos(Vector2(400, 200), active_birb), 0.3, 50],
		[helpers.birb_absolute_pos(Vector2(350, 200), active_birb), 0.5, 50],
		[helpers.birb_absolute_pos(Vector2(450, 200), active_birb), 0.7, 50],
		[helpers.birb_absolute_pos(Vector2(400, 200), active_birb), 0.9, 50],
		[Vector2(0, 0), 1.2, 50]
	]
	
func animate(delta):
	elapsed += delta

	fight.birbs[active_birb].position = helpers.jump_path(path, elapsed)
	
	if helpers.this_frame(0.4, elapsed, delta) or helpers.this_frame(0.6, elapsed, delta) or helpers.this_frame(0.8, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/gains_voice-002.wav"))
		var c = load("res://scenes/Cards/Card_Big_Pecks.tscn").instance()
		fight.add_to_discard(c)
		for _i in range(7):
			var p = preload("res://scenes/Particles/Particle_Droplet.tscn").instance()
			p.init(fight.birbs[active_birb].position + fight.birbs[active_birb].offset)
			fight.add_child(p)			
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
	if helpers.this_frame(0.95, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))		

	
	return elapsed >= duration
