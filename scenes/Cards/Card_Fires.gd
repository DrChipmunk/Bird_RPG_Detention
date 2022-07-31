extends Sprite

var type = "peacock"
var target_type = "enemy"
var card_name = "Fires"
var fight

var duration = 1
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/fire_start-008.wav"))
		
	if helpers.this_frame(0.1, elapsed, delta):
		fight.birbs[active_birb].set_active_sprite(0.3)
		for _i in range(40):
			var p = preload("res://scenes/Particles/Particle_Fireball.tscn").instance()
			p.init(helpers.default_birb_pos(active_birb), helpers.default_enemy_pos(target_enemy))
			fight.add_child(p)
	
	if helpers.this_frame(0.9, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/fire_impact-004.wav"))
		fight.enemies[target_enemy].increase_effect("aflame", 3)
		for _i in range(60):
			var p = preload("res://scenes/Particles/Particle_Flame.tscn").instance()
			p.init(helpers.default_enemy_pos(target_enemy))
			fight.add_child(p)			
	
	return elapsed >= duration
