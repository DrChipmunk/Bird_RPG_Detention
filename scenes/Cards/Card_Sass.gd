extends Sprite

var type = "finch"
var target_type = "none"
var card_name = "Sass"
var fight

var duration = 1.2
var active_birb
var elapsed

var enemy_positions

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	elapsed = 0
	enemy_positions = [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]
	
func animate(delta):
	elapsed += delta
	
	if helpers.this_frame(0.15, elapsed, delta) or helpers.this_frame(0.45, elapsed, delta) or helpers.this_frame(0.75, elapsed, delta) or helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_short-002.wav"))
		var target_enemy = fight.random_living_enemy()
		if target_enemy >= 0:
			fight.damage_enemy(active_birb, target_enemy, 1)
			fight.start_screen_shake(5)
			fight.birbs[active_birb].set_active_sprite(0.3)
			enemy_positions[target_enemy] += helpers.rand_in_circle(35)
			for _i in range(30):
				var p = preload("res://scenes/Particles/Particle_Explosion.tscn").instance()
				p.init(helpers.default_enemy_pos(target_enemy))
				fight.add_child(p)				
				
	for i in range(4):
		fight.enemies[i].position = enemy_positions[i]
		enemy_positions[i] *= 1 - delta * 2

	if helpers.this_frame(1.1, elapsed, delta):
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
	
	return elapsed >= duration
