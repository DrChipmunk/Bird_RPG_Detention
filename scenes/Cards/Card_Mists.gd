extends Sprite

var type = "peacock"
var target_type = "birb"
var card_name = "Mists"
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
	var progress = elapsed / duration
	
	particle_timer += delta
	while particle_timer > 0.05:
		particle_timer -= 0.05
		var p = preload("res://scenes/Particles/Particle_Mist_Wisp.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb))
		get_parent().add_child(p)
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/mists_card-003.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
	
	if helpers.this_frame(0.5, elapsed, delta):
		fight.heal_birb(target_birb, 3)
		
	fight.birbs[target_birb].position = Vector2(-20 * sin(progress * PI * 2), 0)
	
	return elapsed >= duration
