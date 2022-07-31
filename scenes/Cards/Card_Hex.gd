extends Sprite

var type = "swan"
var target_type = "enemy"
var card_name = "Hex"
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
	var progress = elapsed / duration
	var a = 20 - 80 * (progress - 0.5) * (progress - 0.5)
	fight.enemies[target_enemy].position = Vector2(a * sin(progress * 25), 0)
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/hex_card-005.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Hex.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy))
		fight.add_child(p)
	
	if helpers.this_frame(0.9, elapsed, delta):
		fight.enemies[target_enemy].increase_effect("weakened", 1)
	
	return elapsed >= duration
