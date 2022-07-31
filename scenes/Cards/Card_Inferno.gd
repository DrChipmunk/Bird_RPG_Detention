extends Sprite

var type = "peacock"
var target_type = "none"
var card_name = "Inferno"
var fight
var consumable = true

var duration = 2
var active_birb
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	elapsed = 0
	
func animate(delta):
	elapsed += delta
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/fire_long-002.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		
	if randf() < delta * 20 and elapsed < 1.5:
		var y2 = rand_range(40, 315)
		for _i in range(5):
			var p = preload("res://scenes/Particles/Particle_Fireball.tscn").instance()
			p.init(helpers.default_birb_pos(active_birb), Vector2(560, y2))
			fight.add_child(p)
			
	if randf() < delta * 5:
		fight.start_screen_shake(5)
	
	if helpers.this_frame(1.9, elapsed, delta):
		for i in range(4):
			fight.enemies[i].increase_effect("aflame", 3)		
		var c = preload("res://scenes/Cards/Card_Channel.tscn").instance()
		fight.add_to_discard(c)

	
	return elapsed >= duration
