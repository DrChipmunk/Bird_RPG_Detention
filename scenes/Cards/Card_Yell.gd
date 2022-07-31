extends Sprite

var type = "hawk_finch"
var target_type = "none"
var card_name = "Yell"
var fight

var duration = 0.7
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/yell_card-006.wav"))
		
	if elapsed < 0.35 and helpers.n_times_per_second(50, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Sound_Wave.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb))
		get_parent().add_child(p)
		
	if helpers.this_frame(0.65, elapsed, delta):
		for i in range(4):
			fight.enemies[i].change_attacks()
		fight.start_screen_shake(10)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
	
	return elapsed >= duration
