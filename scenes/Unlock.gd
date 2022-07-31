extends Node2D

var cards = []
var curr_card = 0
var timer = 0

var choice = false
var curr_scene = ""

var anim = null
var anim2 = null

func _ready():
	pass

func load_cards(scene):
	curr_scene = scene
	if scene == "magpie":
		cards.append(preload("res://scenes/Cards/Card_Hustle.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Volley.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Winds.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Blood_Rite.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Panic.tscn").instance())
		render_card()
	elif scene == "jocks":
		cards.append(preload("res://scenes/Cards/Card_Rage.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Improvise.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Freeze.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Extort.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Prepare.tscn").instance())
		render_card()
	elif scene == "fangirls":
		cards.append(preload("res://scenes/Cards/Card_Gains.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Taunt.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Spark.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Nevermore.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Heroics.tscn").instance())
		render_card()
	elif scene == "peep":
		choice = true
		cards.append(preload("res://scenes/Cards/Card_Spotlight.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Solo.tscn").instance())
		render_card()
	elif scene == "pidgeons":
		choice = true
		cards.append(preload("res://scenes/Cards/Card_Soulflame.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Bodyslam.tscn").instance())
		render_card()
	elif scene == "swanmother":
		choice = true
		cards.append(preload("res://scenes/Cards/Card_Lifeline.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Deathspike.tscn").instance())
		render_card()
	elif scene == "chickens":
		choice = true
		cards.append(preload("res://scenes/Cards/Card_Radiance.tscn").instance())
		cards.append(preload("res://scenes/Cards/Card_Channel.tscn").instance())
		render_card()
	elif scene == "goose":
		if get_parent().choices["pairing"] == "ry":
			cards.append(preload("res://scenes/Cards/Card_Fortify.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Parry.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Yell.tscn").instance())
			render_card()
		elif get_parent().choices["pairing"] == "rg":
			cards.append(preload("res://scenes/Cards/Card_Focus.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Quake.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Savant.tscn").instance())
			render_card()
		elif get_parent().choices["pairing"] == "yg":
			cards.append(preload("res://scenes/Cards/Card_Lights.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Missile.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Purify.tscn").instance())
			render_card()
	elif scene == "duck":
		if get_parent().choices["pairing"] == "ry":
			cards.append(preload("res://scenes/Cards/Card_Self_Care.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Thorns.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Unravel.tscn").instance())
			render_card()
		elif get_parent().choices["pairing"] == "rg":
			cards.append(preload("res://scenes/Cards/Card_Aegis.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Doomsday.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Revenge.tscn").instance())
			render_card()
		elif get_parent().choices["pairing"] == "yg":
			cards.append(preload("res://scenes/Cards/Card_Headcrack.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Fangs.tscn").instance())
			cards.append(preload("res://scenes/Cards/Card_Terrify.tscn").instance())
			render_card()
		
	if choice:
		get_node("UI/Textbox").texture = preload("res://sprites/unlock_choice.png")
		get_node("UI/Annoucement/Label").text = "Choose One"
		get_node("UI/Textbox/Card").position = Vector2(350, 100)
		get_node("UI/Textbox/Card2").position = Vector2(450, 100)
		get_node("UI/Textbox/Card2").visible = true

func _process(delta):
	timer += delta
	if curr_card < len(cards):
		var card = cards[curr_card]
		if card.type == "any":
			var h = timer * 0.2 - int(timer * 0.2)
			var p = []
			for i in range(4):
				var k = h + 1 - i * 0.25
				while k > 0.5:
					k -= 1
				p.append(k * 1200)
			get_node("Hawk").position = Vector2(421 - p[0], 384)
			get_node("Finch").position = Vector2(403 - p[1], 355)
			get_node("Peacock").position = Vector2(454 - p[2], 428)
			get_node("Swan").position = Vector2(426 - p[3], 435)

func render_card():
	if curr_card >= len(cards):
		get_parent().advance()
		return
	var card = cards[curr_card]
	get_node("UI/Textbox/Card").texture = card.texture
	if choice:
		get_node("UI/Textbox/Card2").texture = cards[curr_card + 1].texture
	if curr_card > 0 and cards[curr_card - 1].type == card.type:
		return
	get_node("Hawk").visible = false
	get_node("Finch").visible = false
	get_node("Peacock").visible = false
	get_node("Swan").visible = false
	if anim:
		anim.queue_free()
	if anim2:
		anim2.queue_free()
	if card.type == "hawk":
		get_node("Hawk").visible = true
		get_node("Hawk").position = Vector2(421, 384)
		anim = preload("res://scenes/Particles/Particle_Hawk_Unlock.tscn").instance()
		anim.position = Vector2(400,300)
		add_child(anim)
	elif card.type == "finch":
		get_node("Finch").visible = true
		get_node("Finch").position = Vector2(403, 355)
		anim = preload("res://scenes/Particles/Particle_Unlock_Finch.tscn").instance()
		anim.position = Vector2(400,300)
		add_child(anim)
	elif card.type == "peacock":
		get_node("Peacock").visible = true
		get_node("Peacock").position = Vector2(454, 428)
		anim = preload("res://scenes/Particles/Particle_Unlock_Peacock.tscn").instance()
		anim.position = Vector2(400,300)
		add_child(anim)
	elif card.type == "swan":
		get_node("Swan").visible = true
		get_node("Swan").position = Vector2(426, 435)
		anim = preload("res://scenes/Particles/Particle_Unlock_Swan.tscn").instance()
		anim.position = Vector2(400,300)
		add_child(anim)
	elif card.type == "any":
		get_node("Hawk").visible = true
		get_node("Finch").visible = true
		get_node("Peacock").visible = true
		get_node("Swan").visible = true
	else:
		var b1 = ""
		var b2 = ""
		if card.type == "hawk_finch":
			b1 = "hawk"
			b2 = "finch"
		elif card.type == "hawk_peacock":
			b1 = "hawk"
			b2 = "peacock"
		elif card.type == "hawk_swan":
			b1 = "hawk"
			b2 = "swan"
		elif card.type == "finch_peacock":
			b1 = "finch"
			b2 = "peacock"
		elif card.type == "finch_swan":
			b1 = "finch"
			b2 = "swan"
		elif card.type == "peacock_swan":
			b1 = "peacock"
			b2 = "swan"
			
		if b1 == "hawk":
			get_node("Hawk").visible = true
			get_node("Hawk").position = Vector2(321, 384)
			anim = preload("res://scenes/Particles/Particle_Hawk_Unlock.tscn").instance()
		elif b1 == "finch":
			get_node("Finch").visible = true
			get_node("Finch").position = Vector2(303, 355)
			anim = preload("res://scenes/Particles/Particle_Unlock_Finch.tscn").instance()
		elif b1 == "peacock":
			get_node("Peacock").visible = true
			get_node("Peacock").position = Vector2(354, 428)
			anim = preload("res://scenes/Particles/Particle_Unlock_Peacock.tscn").instance()
		anim.position = Vector2(300,300)
		add_child(anim)
		anim.half_speed()
		if b2 == "swan":
			get_node("Swan").visible = true
			get_node("Swan").position = Vector2(526, 435)
			anim2 = preload("res://scenes/Particles/Particle_Unlock_Swan.tscn").instance()
		elif b2 == "finch":
			get_node("Finch").visible = true
			get_node("Finch").position = Vector2(503, 355)
			anim2 = preload("res://scenes/Particles/Particle_Unlock_Finch.tscn").instance()
		elif b2 == "peacock":
			get_node("Peacock").visible = true
			get_node("Peacock").position = Vector2(554, 428)
			anim2 = preload("res://scenes/Particles/Particle_Unlock_Peacock.tscn").instance()
		anim2.position = Vector2(500,300)
		add_child(anim2)
		anim2.half_speed()




func make_choice(right):
	if right:
		get_parent().register_card_choice(curr_scene, cards[curr_card + 1].card_name.to_lower())
	else:
		get_parent().register_card_choice(curr_scene, cards[curr_card].card_name.to_lower())

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if event.position.x > 700 and event.position.y > 550:
				var m = preload("res://scenes/Pause_Menu_Nonfight.tscn").instance()
				add_child(m)
				get_tree().paused = true
			elif not choice:
				curr_card += 1
				render_card()
			elif choice:
				if event.position.x > 400 and event.position.x < 500 and event.position.y > 400:
					make_choice(true)
					curr_card += 2
					render_card()
				elif event.position.x > 300 and event.position.x < 400 and event.position.y > 400:
					make_choice(false)
					curr_card += 2
					render_card()
