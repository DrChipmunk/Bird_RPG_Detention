extends Node2D

var target_x = -999
var move_mode = ""
var rest_y = 0
var anim_timer = 0
var fg = false

var bird_images = {
	"Hawk": preload("res://sprites/hawk_talk.png"),
	"Finch": preload("res://sprites/finch_talk.png"),
	"Swan": preload("res://sprites/swan_talk.png"),
	"Ground_Dove": preload("res://sprites/ground_dove_talk.png"),
	"Rock_Pigeon": preload("res://sprites/rock_pigeon_talk.png"),
	"Shadowy_Figure": preload("res://sprites/ground_dove_talk.png"), # pheasant in silhouette
	"Pheasant": preload("res://sprites/ground_dove_talk.png"),
	"Teacher": preload("res://sprites/ground_dove_talk.png"),
	"Peacock": preload("res://sprites/ground_dove_talk.png"),
	"Quail": preload("res://sprites/ground_dove_talk.png"),
	"Magpie": preload("res://sprites/ground_dove_talk.png"),
	"Bluejay": preload("res://sprites/ground_dove_talk.png"),
	"Disguised_Figure": preload("res://sprites/ground_dove_talk.png"), # goose in disguise
	"Eagle": preload("res://sprites/ground_dove_talk.png"),
	"Jocks": preload("res://sprites/ground_dove_talk.png"),
	"Sparrow": preload("res://sprites/ground_dove_talk.png"), # a fangirl
	"Sparrow_2": preload("res://sprites/ground_dove_talk.png"), # a fangirl
	"Robin": preload("res://sprites/ground_dove_talk.png"),
	"Peep": preload("res://sprites/ground_dove_talk.png"),
	"Jacobin": preload("res://sprites/ground_dove_talk.png"),
	"Goose": preload("res://sprites/ground_dove_talk.png"),
	"Duck": preload("res://sprites/ground_dove_talk.png"),
	"White_Swan": preload("res://sprites/ground_dove_talk.png"),
	"Chickens": preload("res://sprites/ground_dove_talk.png"),
	"T-rex": preload("res://sprites/ground_dove_talk.png"),
	"Dinosaurs": preload("res://sprites/ground_dove_talk.png"),
}

var bird_ys = {
	"Hawk": 280,
	"Finch": 370,
	"Swan": 300,
	"Ground_Dove": 275,
	"Rock_Pigeon": 385
}

func _ready():
	pass

func set_bird(bird):
	get_node("Sprite").texture = bird_images[bird]
	if bird in bird_ys:
		get_node("Sprite").position.y = bird_ys[bird]
		rest_y = bird_ys[bird]
	else:
		get_node("Sprite").position.y = 275
		rest_y = 275
		
	
func set_centre_pos(x):
	print(move_mode)
	target_x = x
	if not get_node("Sprite").visible:
		if x < 400:
			get_node("Sprite").position.x = -200
		else:
			get_node("Sprite").position.x = 1000
		get_node("Sprite").visible = true
	if target_x < 400:
		get_node("Sprite").scale = Vector2(-0.35, 0.35)
	else:
		get_node("Sprite").scale = Vector2(0.35, 0.35)
	modulate.a = 1
	if move_mode == "slides":
		get_node("Sprite").position.y = rest_y
	elif move_mode == "walks":
		get_node("Sprite").position.y = rest_y
	elif move_mode == "rises":
		get_node("Sprite").position.y = rest_y + 400
		get_node("Sprite").position.x = target_x
	elif move_mode == "fades":
		if 0 < target_x and target_x < 800:
			modulate.a = 0
		get_node("Sprite").position.y = rest_y
		get_node("Sprite").position.x = target_x
	else:
		get_node("Sprite").position.y = rest_y
		get_node("Sprite").position.x = target_x
	
func _process(delta):
	anim_timer += delta
	if move_mode == "slides":
		get_node("Sprite").position.x += (target_x - get_node("Sprite").position.x) * delta * 4
	elif move_mode == "rises":
		get_node("Sprite").position = get_node("Sprite").position.move_toward(Vector2(target_x, rest_y), delta * 900)
	elif move_mode == "fades":
		if 0 < target_x and target_x < 800:
			modulate.a = min(modulate.a + delta * 2, 1)
		else:
			modulate.a = max(modulate.a - delta * 2, 0)
	elif move_mode == "walks":
		get_node("Sprite").position.x = get_node("Sprite").position.move_toward(Vector2(target_x, rest_y), delta * 200).x
		get_node("Sprite").position.y = rest_y - abs(sin(anim_timer * 6)) * 20
		if get_node("Sprite").position.x > target_x - 1 and get_node("Sprite").position.x < target_x + 1 and get_node("Sprite").position.y > rest_y - 2:
			move_mode = ""
	else:
		get_node("Sprite").position.x = target_x
	
	
#	get_node("Sprite").position.x = target_x
	
func set_foreground(b):
	fg = b
	if b:
		modulate.r = 1
		modulate.g = 1
		modulate.b = 1
	else:
		modulate.r = 0.7
		modulate.g = 0.7
		modulate.b = 0.7
