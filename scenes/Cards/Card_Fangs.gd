extends Sprite

var type = "hawk_swan"
var target_type = "birb"
var card_name = "Fangs"
var fight

var duration = 1
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
	
	particle_timer += delta
	while particle_timer > 0.02:
		particle_timer -= 0.02
		var p = preload("res://scenes/Particles/Particle_Blood_Vortex.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb))
		get_parent().add_child(p)
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/fangs_card-003.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
	
	if helpers.this_frame(0.5, elapsed, delta):
		fight.birbs[target_birb].increase_effect("bloodthirsty", 1)
	
	return elapsed >= duration
