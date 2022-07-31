extends Sprite

var type = "finch_peacock"
var target_type = "enemy"
var card_name = "Missile"
var fight

var duration = 0.8
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
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/missile_card-002.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Missile.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), helpers.default_enemy_pos(target_enemy))
		fight.add_child(p)
		
	if helpers.this_frame(0.75, elapsed, delta):
		fight.damage_enemy(active_birb, target_enemy, 2)
		fight.birbs[active_birb].give_action()
		fight.start_screen_shake(5)
		
	
	return elapsed >= duration
