extends BossAttack

@export var beam_thickness: float = 3

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	var window_size := get_window().size
	if randi_range(1, 2) == 1:
		var x_coord = randi_range(0, window_size.x)
		paint_layer.paint_line_world(Vector2(x_coord, 0), Vector2(x_coord, window_size.y), boss.get_random_color(), beam_thickness)
	else:
		var y_coord = randi_range(0, window_size.y)
		paint_layer.paint_line_world(Vector2(0, y_coord), Vector2(window_size.x, y_coord), boss.get_random_color(), beam_thickness)

	await get_tree().create_timer(1).timeout
	end_attack()

