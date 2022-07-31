extends Sprite

var type = "peacock"
var target_type = "none"
var card_name = "Spark"
var fight

var duration = 0.6
var active_birb
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	elapsed = 0
	direction = 0
	
var direction
	
func animate(delta):
	elapsed += delta
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/spark_card-003.wav"))
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Play_First_Card.tscn"), -1)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)		
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Play_First_Card.tscn"), -1)
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)	
		
	if helpers.n_times_per_second(100, elapsed, delta) and elapsed < 0.3:
		var p = preload("res://scenes/Particles/Particle_Spark.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), direction)
		fight.add_child(p)
		direction += PI * 2 / 3 + 0.01
		if direction > PI * 2:
			direction -= PI * 2
		

	
	return elapsed >= duration
