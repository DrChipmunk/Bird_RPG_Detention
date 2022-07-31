extends Node2D



func _ready():
	get_node("Layer_1").init(Vector2(100, 100))
	get_node("Layer_2").init(Vector2(128, 87))
	get_node("Layer_3").init(Vector2(116, 118))
	get_node("Layer_4").init(Vector2(380, 157))
