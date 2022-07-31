extends Sprite

var type = "finch"
var target_type = "enemy"
var card_name = "Taunt"
var fight

var duration = 1.5
var active_birb
var target_enemy
var elapsed

var jump_path

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_enemy = target
	jump_path = [[Vector2(0, 0), 0, 0],
		[helpers.birb_absolute_pos(helpers.default_enemy_pos(target_enemy) + Vector2(-70, 0), active_birb), 0.6, 50],
		[helpers.birb_absolute_pos(helpers.default_enemy_pos(target_enemy) + Vector2(-60, 0), active_birb), 0.9, 10],
		[Vector2(0, 0), 1.5, 50]]
	elapsed = 0
	
func animate(delta):
	elapsed += delta

	fight.birbs[active_birb].position = helpers.jump_path(jump_path, elapsed)
	
	if helpers.this_frame(0.75, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/taunt_voice-003.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Taunt.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy))
		fight.add_child(p)
		fight.start_screen_shake(5)
		fight.birbs[active_birb].increase_effect("defence", 4)
		for attack in fight.enemies[target_enemy].attacks:
			attack.target_birb = active_birb
	
	return elapsed >= duration
