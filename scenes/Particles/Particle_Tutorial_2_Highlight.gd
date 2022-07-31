extends Node2D

var fight

func _ready():
	pass
	
func _process(delta):
	if not fight:
		fight = get_parent()
		
	if fight.turn_count == 1:
		pass
	else:
		get_node("Sprite").visible = false
		get_node("Sprite2").position = Vector2(550,325)
		get_node("Sprite2").texture = preload("res://sprites/survive_the_turn.png")
