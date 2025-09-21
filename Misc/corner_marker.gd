extends Node2D
class_name CornerMarker

@export var bottom_right_corner := false

func _ready() -> void:
	if bottom_right_corner:
		add_to_group("bottom_right")
	else:
		add_to_group("top_left")
