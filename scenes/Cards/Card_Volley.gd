extends Sprite

var type = "finch"
var target_type = "enemy"
var card_name = "Volley"
var fight

var duration = 0.6
var active_birb
var target_enemy
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_enemy = target
	elapsed = 0
	
func animate(delta):
	elapsed += delta
		
	if elapsed < 0.5:
		var progress = elapsed / 0.5
		fight.birbs[active_birb].position = helpers.jump_lerp(Vector2(0, 0), Vector2(0, 0), progress, -50)
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
		
	if helpers.this_frame(0.5, elapsed, delta):
		fight.birbs[active_birb].set_active_sprite(0.3)
		fight.enemies[target_enemy].increase_effect("volley", 6)
		var p = preload("res://scenes/Particles/Particle_Volley_Up.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), false)
		fight.add_child(p)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/volley_up-005.wav"))		
	
	return elapsed >= duration
