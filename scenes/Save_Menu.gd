extends Node2D

var elapsed = 0

func _ready():
	pass

func _process(delta):
	elapsed += delta
	if elapsed < 0.3:
		get_node("Sprite").position.y = 40 + 700 * (0.3 - elapsed) * (0.3 - elapsed) / 0.09
	else:
		get_node("Sprite").position.y = 40

		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and elapsed > 0.3:
			var x = event.position.x
			var y = event.position.y
			if x > 559 and x < 589 and y > 51 and y < 81:
				if get_parent().has_method("remove_other_menu"):
					get_parent().remove_other_menu()
				queue_free()
