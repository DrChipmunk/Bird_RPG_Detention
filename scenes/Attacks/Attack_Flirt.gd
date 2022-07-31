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

var pickup_lines = ["I'd let you regurgitate in my mouth", 
	"Are you a murder? Cause I'd get away with you",
	"You are the wind beneath my wings",
	"We belong together like a nut and a screw",
	"Am I a mirror? Because I can see you in me",
	"Quack <3",
	";)",
	"If you were a fart, I'd hold you in",
	"You are my tall, dark, and handsome stranger",
	"Come here often?",
	"You'll always be my fluffbirb!"]

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
		
	if helpers.this_frame(0.05, elapsed, delta):
		var d = preload("res://scenes/Particles/Battle_Dialogue.tscn").instance()
		get_parent().add_child(d)
		d.set_text(helpers.rand_choice(pickup_lines))
		d.set_enemy_speaking(true)
		d.set_speaker_pos(helpers.default_enemy_pos(active_enemy))
		d.lifetime = 3

	if helpers.this_frame(0.9, elapsed, delta):
		var k = fight.damage_birb(active_enemy, target_birb, damage)
		for _i in range(k):
			var c = preload("res://scenes/Cards/Card_Cringe.tscn").instance()
			fight.add_child(c)
			fight.deck.append(c)
			c.visible = false
			fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
	
	return elapsed >= duration
