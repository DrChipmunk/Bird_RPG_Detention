extends Sprite

var type = "hawk_peacock"
var target_type = "enemy"
var card_name = "Quake"
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
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/stone_long-004.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Quake.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), helpers.default_enemy_pos(target_enemy) + Vector2(0, 30))
		fight.add_child(p)
		p = preload("res://scenes/Particles/Particle_Quake.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), helpers.default_enemy_pos(target_enemy) + Vector2(0, 30))
		fight.add_child(p)
		
	if helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/stone_impact-002.wav"))
		for _i in range(40):
			var p = preload("res://scenes/Particles/Particle_Stone_Fragment.tscn").instance()
			p.init(helpers.default_enemy_pos(target_enemy) + Vector2(0, 30))
			fight.add_child(p)					
		fight.enemies[target_enemy].increase_effect("quake", 3)
		fight.start_screen_shake(20)
		
		
	
	return elapsed >= duration
