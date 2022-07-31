extends Sprite

var type = "peacock"
var target_type = "none"
var card_name = "Channel"
var fight
var consumable = true

var duration = 2
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/channel_card-004.wav"))
		for a in range(9):
			for b in range(5):
				var p = preload("res://scenes/Particles/Particle_Channel.tscn").instance()
				p.init(helpers.default_birb_pos(active_birb), a, b)
				fight.add_child(p)
	
	if helpers.this_frame(1.9, elapsed, delta):
		var c = load("res://scenes/Cards/Card_Inferno.tscn").instance()
		fight.add_to_discard(c)
	
	return elapsed >= duration
