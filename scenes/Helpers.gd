extends Node

static func jump_lerp(p_from, p_to, progress, jump_height):
	var p_x = p_to.x * progress + p_from.x * (1 - progress)
	var p_y = p_to.y * progress + p_from.y * (1 - progress)
	var j = jump_height * (1 - 4 * (progress - 0.5) * (progress - 0.5))
	return Vector2(p_x, p_y - j)

static func tween(positions, progress):
	var n = len(positions)
	var pos = Vector2(0, 0)
	var m = 1
	for i in range(n):
		var k = 1
		for _j in range(i):
			k *= progress
		for _j in range(n - i - 1):
			k *= 1 - progress
		pos += positions[i] * m * k
		if i < n - 1:
			m = m * (n - i - 1)
			m = m / (i + 1)
	return pos

static func birb_absolute_pos(screen_pos, birb):
	return screen_pos - Vector2(260, 45 + 90 * birb)
	
static func default_birb_pos(birb):
	return Vector2(260, 45 + 90 * birb)
	
static func default_enemy_pos(enemy):
	return Vector2(540, 45 + 90 * enemy)
	
static func enemy_absolute_pos(screen_pos, enemy):
	return screen_pos - Vector2(540, 45 + 90 * enemy)
	
static func this_frame(target, elapsed, delta):
	return elapsed - delta <= target and elapsed > target
	
static func rand_choice(list):
	return list[randi() % len(list)]
	
static func rand_in_circle(radius):
	var k = randf()
	k = sqrt(k)
	var a = randf() * 2 * PI
	return Vector2(k * radius, 0).rotated(a)	
	
static func n_times_per_second(n, elapsed, delta):
	var k = elapsed * n - int(elapsed * n)
	return k < n * delta
	
static func jump_path(path, elapsed):
	# path is list of [location, time, jump_height]
	if elapsed <= path[0][1]:
		return path[0][0]
	if elapsed >= path[-1][1]:
		return path[-1][0]
	var k = 0
	for i in range(len(path)):
		if path[i][1] > elapsed:
			k = i
			break
	var progress = (elapsed - path[k-1][1]) / (path[k][1] - path[k-1][1])
	return jump_lerp(path[k-1][0], path[k][0], progress, path[k][2])
	
static func effect_sprite(effect):
	var effect_sprites = {
		"defence": preload("res://sprites/effect_defence.png"),
		"aflame": preload("res://sprites/effect_aflame.png"),
		"quake": preload("res://sprites/effect_quake.png"),
		"frozen": preload("res://sprites/effect_frozen.png"),
		"frozen_delayed": preload("res://sprites/effect_frozen.png"),
		"volley": preload("res://sprites/effect_volley.png"),
		"volley_imminent": preload("res://sprites/effect_volley_down.png"),
		"prepared": preload("res://sprites/effect_prepared.png"),
		"shattered": preload("res://sprites/effect_shattered.png"),
		"shattered_imminent": preload("res://sprites/effect_shattered.png"),
		"weakened": preload("res://sprites/effect_weakened.png"),
		"hype": preload("res://sprites/effect_hype.png"),
		"kissed": preload("res://sprites/effect_kissed.png"),
		"fortified": preload("res://sprites/effect_fortified.png"),
		"thorns": preload("res://sprites/effect_thorns.png"),
		"rage": preload("res://sprites/effect_rage.png"),
		"hustle": preload("res://sprites/effect_hustle.png"),
		"hustle_delayed": preload("res://sprites/effect_focus.png"),
		"confused": preload("res://sprites/effect_confused.png"),
		"quick": preload("res://sprites/effect_quick.png"),
		"stun": preload("res://sprites/effect_stun.png"),
		"regenerating": preload("res://sprites/effect_regenerating.png"),
		"immune": preload("res://sprites/effect_immune.png"),
		"immune_imminent": preload("res://sprites/effect_immune.png"),
		"parrying": preload("res://sprites/effect_parrying.png"),
		"bloodthirsty": preload("res://sprites/effect_bloodthirsty.png")
		}	
	return effect_sprites[effect]
	
static func effect_description_birb(effect, amount):
	var birb_text = {
		"defence": "Prevent the next %d damage dealt",
		"aflame": "Take %d damage at end of turn (reduces by 1 each turn)",
		"quake": "ERROR",
		"frozen": "Take +%d damage from all sources this turn",
		"frozen_delayed": "Take +%d damage from all sources next turn",
		"volley": "Take %d damage at end of next turn",
		"volley_imminent": "Take %d damage at end of this turn",
		"prepared": "+1 action for the next %d turn(s)",
		"shattered": "Take double damage from the next source of damage this turn",
		"shattered_imminent": "Take double damage from the next source of damage this turn",
		"weakened": "ERROR",
		"hype": "ERROR",
		"kissed": "ERROR",
		"fortified": "Deal %d damage to a random enemy each turn (damage will remove this)",
		"thorns": "ERROR",
		"rage": "ERROR",
		"hustle": "Copy the next %d card(s) played this turn",
		"hustle_delayed": "Copy the first %d card(s) played next turn",
		"confused": "The next %d card(s) played by this birb will have a random target",
		"quick": "ERROR",
		"stun": "-1 action for the next %d turn(s)",
		"regenerating": "Regain 1 health at the end of each turn for %d turns",
		"immune": "Immune to damage this turn",
		"immune_imminent": "Immune to damage next turn",
		"parrying": "Prevent and reflect back the next %d damage dealt",
		"bloodthirsty": "Gain health when dealing damage to enemies this turn",
	}
	return birb_text[effect].replace("%d", str(amount))
	
static func effect_description_enemy(effect, amount):
	var enemy_text = {
		"defence": "Prevent the next %d damage dealt",
		"aflame": "Take %d damage at end of turn (reduces by 1 each turn)",
		"quake": "Take 2 damage at end of turn for %d turn(s)",
		"frozen": "Take +%d damage from all sources this turn",
		"frozen_delayed": "ERROR",
		"volley": "Take %d damage at end of next turn",
		"volley_imminent": "Take %d damage at end of this turn",
		"prepared": "ERROR",
		"shattered": "Take double damage from the next source of damage this turn",
		"shattered_imminent": "ERROR",
		"weakened": "Deal half damage (rounded down) for %d turn(s)",
		"hype": "This enemy is HYPE %d! Attacks will be twice as strong for each stack",
		"fortified": "ERROR",
		"thorns": "Takes +1 damage the next %d time(s) they take damage",
		"kissed": "This enemy's next action will be more powerful",
		"rage": "She's mad! Her attacks will deal %d damage",
		"hustle": "Will act twice next turn (damage will remove this)",
		"hustle_delayed": "ERROR",
		"confused": "ERROR",
		"quick": "Gotta get quick! Attack %d more time(s) each turn",
		"stun": "ERROR",
		"regenerating": "ERROR",
		"immune": "ERROR",
		"immune_imminent": "ERROR",
		"parrying": "ERROR",
		"bloodthirsty": "ERROR",
		}
	return enemy_text[effect].replace("%d", str(amount))
	
var effects = ["rage", "quick", "hype", "kissed", 
	"immune", "immune_imminent", "defence", "parrying",
	"shattered", "shattered_imminent", "frozen", "frozen_delayed", "thorns",
	"weakened", "bloodthirsty", "confused",
	"volley", "volley_imminent", "aflame", "regenerating", "quake", "fortified",
	"hustle", "hustle_delayed", "stun", "prepared"]	
	

	
func _ready():
	pass
