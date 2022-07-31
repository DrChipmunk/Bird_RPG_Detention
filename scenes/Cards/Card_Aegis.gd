extends Sprite

var type = "finch_swan"
var target_type = "none"
var card_name = "Aegis"
var fight

var duration = 1
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
	var start_pos = Vector2(0, 0)

	if helpers.this_frame(0.05, elapsed, delta):
		fight.birbs[active_birb].set_active_sprite(0.3)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/missile_card-002.wav"))
		
	if randf() < delta * 10:
		var progress = elapsed / duration
		var offset = progress * 350
		var y = helpers.default_birb_pos(active_birb).y
		if y + offset < 400:
			var p = preload("res://scenes/Particles/Particle_Guard.tscn").instance()
			p.init(helpers.default_birb_pos(active_birb) + Vector2(30, offset), false)
			get_parent().add_child(p)
		if y - offset > 0:
			var p = preload("res://scenes/Particles/Particle_Guard.tscn").instance()
			p.init(helpers.default_birb_pos(active_birb) + Vector2(30, -offset), false)
			get_parent().add_child(p)
		
	if helpers.this_frame(0.5, elapsed, delta):
		for i in range(4):
			if i != active_birb:
				fight.birbs[i].increase_effect("defence", 2)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/guard_v2-002.wav"))
	
	return elapsed >= duration
