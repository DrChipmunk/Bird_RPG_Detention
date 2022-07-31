extends Sprite

var type = "peacock_swan"
var target_type = "enemy"
var card_name = "Unravel"
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
		for i in range(15):
			for j in range(3):
				var p = preload("res://scenes/Particles/Particle_Unravel.tscn").instance()
				p.init(helpers.default_enemy_pos(target_enemy), j * PI * 2 / 3 + i * 0.35, 100 - i * 4, 0.49 - i * 0.03)
				fight.add_child(p)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/unravel_card-004.wav"))		
		fight.birbs[active_birb].set_active_sprite(0.3)
		
	if helpers.this_frame(0.55, elapsed, delta):
		var d = 0
		for effect in fight.enemies[target_enemy].effects:
			if fight.enemies[target_enemy].effects[effect] > 0:
				d += 3
		fight.damage_enemy(active_birb, target_enemy, d)
		
		
	
	return elapsed >= duration
