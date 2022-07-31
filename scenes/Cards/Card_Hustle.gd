extends Sprite

var type = "hawk"
var target_type = "birb"
var card_name = "Hustle"
var fight

var duration = 1
var active_birb
var target_birb
var elapsed

var path1
var path2

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_birb = target
	elapsed = 0
	
	path1 = [
		[Vector2(0, 0), 0, 0],
		[Vector2(20, 0), 0.22, 40],
		[Vector2(-20, 0), 0.44, 40],
		[Vector2(0, 0), 0.66, 40],
		[Vector2(0, 0), 1, 0],
	]
	
	path2 = [
		[Vector2(0, 0), 0, 0],
		[Vector2(0, 0), 0.34, 0],
		[Vector2(20, 0), 0.56, 40],
		[Vector2(-20, 0), 0.78, 40],
		[Vector2(0, 0), 1, 40],
	]
	
func animate(delta):
	elapsed += delta
	

	fight.birbs[active_birb].position = helpers.jump_path(path1, elapsed)

	fight.birbs[target_birb].position = helpers.jump_path(path2, elapsed)
	
	if helpers.this_frame(0.33, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/hustle_card-005.wav"))
		fight.birbs[active_birb].set_active_sprite(0.2)
		var p = preload("res://scenes/Particles/Particle_Hustle.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb))
		fight.add_child(p)
	
	if helpers.this_frame(0.45, elapsed, delta):
		fight.birbs[target_birb].set_active_sprite(0.2)
		fight.birbs[target_birb].increase_effect("hustle", 1)
		var p = preload("res://scenes/Particles/Particle_Hustle.tscn").instance()
		p.init(helpers.default_birb_pos(target_birb))
		fight.add_child(p)
	
	return elapsed >= duration
