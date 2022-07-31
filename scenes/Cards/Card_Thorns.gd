extends Sprite

var type = "peacock_swan"
var target_type = "enemy"
var card_name = "Thorns"
var fight

var duration = 1.1
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/thorns_card.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		for _i in range(7):
			var p = preload("res://scenes/Particles/Particle_Thorns_Trail.tscn").instance()
			p.init(helpers.default_enemy_pos(target_enemy))
			fight.add_child(p)
	
		
	if helpers.this_frame(1.05, elapsed, delta):				
		fight.enemies[target_enemy].increase_effect("thorns", 6)
		fight.start_screen_shake(10)
		
		
	
	return elapsed >= duration
