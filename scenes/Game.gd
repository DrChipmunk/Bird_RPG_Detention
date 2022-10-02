extends Node2D

var sound_effect_player

var curr_scene
var curr_transition_anim = 1

var transition_anims = {
	"tutorial_1": 1,
	"tutorial_2": 10,
	"magpie": 2,
	"jocks": 9,
	"fangirls": 8,
	"peep": 13,
	"pidgeons": 7,
	"duck": 6,
	"goose": 11,
	"swanmother": 3,
	"chickens": 5,
	"pheasant": 12,
	"dinosaurs": 12
}

var transition_tiles = []

var choices = {
	"pairing": "ry",
	"hawk": "bodyslam",
	"finch": "spotlight",
	"peacock": "channel",
	"swan": "deathspike"
}

func register_card_choice(scene, choice):
	if scene == "peep":
		choices["finch"] = choice
	elif scene == "pidgeons":
		choices["hawk"] = choice
	elif scene == "swanmother":
		choices["swan"] = choice
	elif scene == "chickens":
		choices["peacock"] = choice

var saved_deck = ""
var available_cards = []

var helpers = preload("res://scenes/Helpers.gd")
var tile_scene = preload("res://scenes/Transistion_Tile.tscn")

var active_screen = null

func load_scene(scene):
	if scene["type"] == "fight":
		if active_screen:
			active_screen.queue_free()
		var fight = preload("res://scenes/Fight.tscn").instance()
		add_child(fight)
		fight.start_fight(scene["name"], choices)
		fight.string_to_deck(saved_deck, available_cards)
		fight.available_cards = available_cards
		active_screen = fight
	elif scene["type"] == "deck":
		if active_screen:
			active_screen.queue_free()
		var deck = preload("res://scenes/Deck.tscn").instance()
		add_child(deck)
		deck.setup_available_cards(scene["name"], choices)
		deck.string_to_deck(saved_deck)
		active_screen = deck
	elif scene["type"] == "talk":
		if active_screen:
			active_screen.queue_free()
		var talk = preload("res://scenes/Talk.tscn").instance()
		if "##" in scene["name"]:
			scene["name"] = scene["name"].replace("##", choices["pairing"])
		talk.load_script(scene["name"])
		add_child(talk)
		active_screen = talk
	elif scene["type"] == "unlock":
		if active_screen:
			active_screen.queue_free()
		var unlock = preload("res://scenes/Unlock.tscn").instance()
		add_child(unlock)
		unlock.load_cards(scene["name"])
		active_screen = unlock
	elif scene["type"] == "fight_cont":
		active_screen.dinosaur_start()
		
func unload_scene(scene):
	if scene["type"] == "deck":
		saved_deck = active_screen.deck_to_string()
		available_cards = active_screen.get_available_cards()
		
func _ready():
#	var fight = preload("res://scenes/Fight.tscn").instance()
#	add_child(fight)
	randomize()

	load_script()
	load_scene(curr_scene)

var transition_anim_timer = 0
var transitioning = false

var victory_anim_timer = 0
var in_victory = false

var defeat_anim_timer = 0
var in_defeat = false



func add_transition_tiles():
	transition_tiles = []
	var anim = 1
	for a in range(8):
		for b in range(6):
			var tile = tile_scene.instance()
			get_node("Tiles").add_child(tile)
			tile.init(curr_transition_anim, Vector2(a * 100, b * 100))
			transition_tiles.append(tile)
	get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/tile_transition_in-001.wav"))

var next_scene = 0

func advance():
	if not in_victory and not in_defeat and not transitioning:
		get_tree().paused = true
		transition_anim_timer = 0
		transitioning = true
		next_scene = scene_list[curr_scene["next"]]
		if next_scene["name"] in transition_anims:
			curr_transition_anim = transition_anims[next_scene["name"]]
		add_transition_tiles()
	
func advance_victory():
	if not in_victory and not in_defeat and not transitioning:
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/victory_fanfare-004.wav"))
		victory_anim_timer = 0
		in_victory = true
		get_node("Victory_1").visible = true
		get_node("Victory_2").visible = true
		next_scene = scene_list[curr_scene["next"]]
		if next_scene["name"] in transition_anims:
			curr_transition_anim = transition_anims[next_scene["name"]]
		set_victory_positions()
		
func advance_defeat():
	if not in_victory and not in_defeat and not transitioning:
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/defeat_fanfare-001.wav"))
		defeat_anim_timer = 0
		in_defeat = true
		get_node("Game_Over_1").visible = true
		get_node("Game_Over_2").visible = true
		next_scene = scene_list[curr_scene["prev"]]
		if next_scene["name"] in transition_anims:
			curr_transition_anim = transition_anims[next_scene["name"]]
		set_defeat_positions()
	
func set_victory_positions():
	var p = float(victory_anim_timer) / 0.7
	var vec = Vector2(-(p - 1) * (0.3 - p) * 1500, 400 * (1 - p))
	get_node("Victory_1").position = Vector2(300,250) + vec
	get_node("Victory_2").position = Vector2(300,250) - vec
	
func set_defeat_positions():
	var p = float(defeat_anim_timer) / 0.7
	var vec = Vector2(0, (1 - p * p) * 400)
	get_node("Game_Over_1").position = Vector2(300,250) - vec
	get_node("Game_Over_2").position = Vector2(300,300) + vec
	
func _process(delta):
	if in_victory:
		victory_anim_timer += delta
		if victory_anim_timer > 0.7:
			victory_anim_timer = 0.7
			set_victory_positions()
			get_tree().paused = true
			transition_anim_timer = 0
			transitioning = true
			in_victory = false
			add_transition_tiles()
		set_victory_positions()
	elif in_defeat:
		defeat_anim_timer += delta
		if defeat_anim_timer > 0.7:
			defeat_anim_timer = 0.7
			set_defeat_positions()
			get_tree().paused = true
			transition_anim_timer = 0
			transitioning = true
			in_defeat = false
			add_transition_tiles()
		set_defeat_positions()
	elif transitioning:
		transition_anim_timer += delta
		if transition_anim_timer < 1:
			for tile in transition_tiles:
				tile.in_anim(transition_anim_timer)
		elif transition_anim_timer < 2:
			for tile in transition_tiles:
				tile.out_anim(transition_anim_timer - 1)			
		if helpers.this_frame(1, transition_anim_timer, delta):
			unload_scene(curr_scene)
			curr_scene = next_scene
			load_scene(curr_scene)
			get_node("Victory_1").visible = false
			get_node("Victory_2").visible = false
			get_node("Game_Over_1").visible = false
			get_node("Game_Over_2").visible = false
			get_tree().paused = false
			get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/tile_transition_out-001.wav"))
		if transition_anim_timer > 2:
			transitioning = false
			for tile in transition_tiles:
				tile.queue_free()
			
var scene_list = []
		
	
		
func load_script():
	var file = File.new()
	file.open("res://scripts/master.txt", File.READ)
	var content = file.get_as_text().strip_edges()
	file.close()
	var lines = content.split("\n")
	for i in range(len(lines)) :
		var line = lines[i]
		var tokens = line.strip_edges().split(" ")
		var scene = {
			"type": tokens[0],
			"name": tokens[1],
			"next": i + 1,
			"prev": i - 1,
		}
		scene_list.append(scene)
	curr_scene = scene_list[0]
#TODO
# talk mode
#  emotes
#  background changes
#  more animations
#  load in scripts
# unlock mode
#  background per unlock
# menus
#  sound options
#  save
#  load
# general
#  music engine
#  effects
#  dynamic card text
#  reword cards
#  export text files and package as zip
#  polish
# tutorial
#  redesign
#  rewrite
#  playtest 


#fix pausing
#talk mode
#main menu
#save / load
