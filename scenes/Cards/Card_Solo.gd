extends Sprite

var type = "finch"
var target_type = "none"
var card_name = "Solo"
var fight

var duration = 4
var active_birb
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	elapsed = 0
	get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/solo_card-005.wav"))
	
func animate(delta):
	elapsed += delta

	for i in range(7):
		var index = (i * 3 + 1) % 7
		if helpers.this_frame(i * 0.5 + 0.25, elapsed, delta):			
			fight.birbs[active_birb].set_active_sprite(0.2)
			for _i in range(10):
				var p = preload("res://scenes/Particles/Particle_Improvise.tscn").instance()
				p.init(Vector2(index * 100 + 50, 500), rand_range(-PI, PI))
				get_parent().add_child(p)
			if fight.hand[index]:
				fight.add_to_discard(fight.hand[index])
				fight.hand[index] = null
			var card = fight.random_available_card().instance()
			fight.hand[index] = card
			fight.add_child(card)
			if i == 2 or i == 5:
				fight.birbs[active_birb].actions += 1
		if fight.hand[index]:
#			fight.hand[index].position = Vector2(5 + 100 * index, 405)
			if i * 0.5 < elapsed and elapsed < i * 0.5 + 0.5:
				var a = (0.25 * 0.25 - (i * 0.5 + 0.25 - elapsed) *  (i * 0.5 + 0.25 - elapsed)) * 1200
				fight.hand[index].position = Vector2(5 + 100 * index, 405) + Vector2(a, 0).rotated(elapsed * 25)
		
				
	
	return elapsed >= duration
