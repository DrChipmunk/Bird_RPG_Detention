extends Sprite

var hp
var max_hp
var actions
var effects

var index

var active_sprite_timer = 0

func _ready():
	pass
	
func init(i):
	max_hp = [10, 15, 12, 10][i]
	index = i
	hp = max_hp
	actions = 1
	effects = {}
	for effect in get_parent().effects:
		effects[effect] = 0

func set_active_sprite(duration):
	active_sprite_timer = duration
	if index == 0:
		texture = preload("res://sprites/hawk_active.png")
	elif index == 1:
		texture = preload("res://sprites/finch_active.png")
	elif index == 2:
		texture = preload("res://sprites/peacock_active.png")
	elif index == 3:
		texture = preload("res://sprites/swan_active.png")

func give_action():
	if hp > 0 and actions < 4:
		actions += 1

func increase_effect(effect, amount):
	if hp > 0:
		effects[effect] += amount

func _process(delta):
	if active_sprite_timer > 0:
		active_sprite_timer -= delta
		if active_sprite_timer <= 0:
			if index == 0:
				texture = preload("res://sprites/hawk_idle.png")
			elif index == 1:
				texture = preload("res://sprites/finch_idle.png")
			elif index == 2:
				texture = preload("res://sprites/peacock_idle.png")
			elif index == 3:
				texture = preload("res://sprites/swan_idle.png")			
	if hp <= 0:
		visible = false
	else:
		visible = true
