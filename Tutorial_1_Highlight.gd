extends Node2D

var fight

func _ready():
	pass
	
func _process(delta):
	if not fight:
		fight = get_parent()
		
	if fight.turn_count == 1:
		if fight.state == fight.STATE_CHOICE:
			if fight.hand[0]:
				get_node("Sprite").texture = preload("res://sprites/tutorial_highlight_1a.png")
			else:
				get_node("Sprite").texture = preload("res://sprites/tutorial_highlight_1d.png")
		elif fight.state == fight.STATE_SELECT_BIRB:
			get_node("Sprite").texture = preload("res://sprites/tutorial_highlight_1b.png")
		elif fight.state == fight.STATE_SELECT_TARGET:
			get_node("Sprite").texture = preload("res://sprites/tutorial_highlight_1c.png")
	if fight.turn_count == 2:
		get_node("Sprite").texture = preload("res://sprites/tutorial_turn_2_text_1.png")
		get_node("Sprite").position = Vector2(400,225)
		get_node("Sprite2").texture = preload("res://sprites/tutorial_turn_2_text_2.png")
		get_node("Sprite2").position = Vector2(400,275)
		get_node("Sprite2").visible = true
	if fight.turn_count == 3:
		get_node("Sprite").texture = preload("res://sprites/tutorial_turn_3_text_1.png")
		get_node("Sprite").position = Vector2(400,300)
		get_node("Sprite2").texture = preload("res://sprites/tutorial_turn_3_text_2.png")
		get_node("Sprite2").position = Vector2(400,350)
	if fight.turn_count == 4:
		get_node("Sprite").texture = preload("res://sprites/survive_the_turn.png")
		get_node("Sprite").position = Vector2(400,350)
		get_node("Sprite2").visible = false
