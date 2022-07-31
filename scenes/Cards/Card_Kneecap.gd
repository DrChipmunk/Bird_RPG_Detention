extends Sprite

var type = "swan"
var target_type = "enemy"
var card_name = "Kneecap"
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/smoke_fade-003.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Kneecap.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), helpers.default_enemy_pos(target_enemy))
		fight.add_child(p)
		
	if helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/kneecap_card_v2-002.wav"))
		var p = preload("res://scenes/Particles/Particle_Shatter_Cross.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy))
		fight.add_child(p)	
		for _i in range(60):
			p = preload("res://scenes/Particles/Particle_Smoke_Cloud.tscn").instance()
			p.init(helpers.default_enemy_pos(target_enemy))
			fight.add_child(p)					
		fight.damage_enemy(active_birb, target_enemy, 2)
		fight.start_screen_shake(20)
		fight.enemies[target_enemy].increase_effect("shattered", 1)
		
		
	
	return elapsed >= duration
