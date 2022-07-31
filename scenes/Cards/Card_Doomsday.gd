extends Sprite

var type = "finch_swan"
var target_type = "none"
var card_name = "Doomsday"
var fight
var consumable = true

var duration = 1.9
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/doomsday_card-001.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Rocket.tscn").instance()
		p.init()
		fight.add_child(p)
		
	if helpers.n_times_per_second(5, elapsed, delta):
		fight.start_screen_shake(10)
	
	if helpers.this_frame(1.85, elapsed, delta):
		for i in range(4):
			fight.enemies[i].increase_effect("volley", 4)		
		fight.birbs[active_birb].increase_effect("volley", 4)
	
	return elapsed >= duration
