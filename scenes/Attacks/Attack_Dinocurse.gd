extends Node

var basic_attack = false
var fight

var duration = 1
var active_enemy
var target_birb
var damage

var elapsed
var path

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, target, amount):
	active_enemy = active
	target_birb = target
	damage = amount
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	path = [
		[Vector2(0, 0), 0, 0],
		[Vector2(20, 0), 0.22, 40],
		[Vector2(-20, 0), 0.44, 40],
		[Vector2(0, 0), 0.66, 40],
		[Vector2(0, 0), 1, 0],
	]
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	var a = 20 - 80 * (progress - 0.5) * (progress - 0.5)
	fight.birbs[target_birb].position = Vector2(a * sin(progress * 25), 0)
	fight.enemies[active_enemy].position = helpers.jump_path(path, elapsed)
		
	if helpers.this_frame(0.05, elapsed, delta) or helpers.this_frame(0.33, elapsed, delta) or helpers.this_frame(0.55, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/kiss_effect-002.wav"))

	if helpers.this_frame(0.9, elapsed, delta):
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		for _i in range(k):
			var c = preload("res://scenes/Cards/Card_Dinocurse.tscn").instance()
			fight.add_child(c)
			fight.deck.append(c)
			c.visible = false
			fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
	
	return elapsed >= duration
