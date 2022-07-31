extends Sprite

var type = "finch_peacock"
var target_type = "birb"
var card_name = "Purify"
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
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/purify_card-004.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		
	if helpers.n_times_per_second(75, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Purify.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb), rand_range(-PI, PI), 10 + elapsed * 90)
		fight.add_child(p)
	
	if helpers.this_frame(0.5, elapsed, delta):
		for effect in fight.birbs[target_birb].effects:
			fight.birbs[target_birb].effects[effect] = 0
		
	
	return elapsed >= duration
