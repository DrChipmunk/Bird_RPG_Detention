extends Sprite

var fight

func _ready():
	pass

func _process(delta):
	fight = get_parent()
	get_node("Deck_Icon/Number").text = str(len(get_parent().deck))
	get_node("Discard_Icon/Number").text = str(len(get_parent().discard))
	if fight.card_tray_active():
		texture = preload("res://sprites/card_tray.png")
	else:
		texture = preload("res://sprites/card_tray_inactive.png")
	if fight.any_card_can_be_played():
		get_node("End_Turn_Button").texture = preload("res://sprites/end_turn_off.png")
	else:
		get_node("End_Turn_Button").texture = preload("res://sprites/end_turn.png")	
