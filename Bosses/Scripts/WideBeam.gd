extends BossAttack

@export var beam_thickness: float = 3
@export var impact_damage: int = 15

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	var window_size := get_window().size
	var player_cell := paint_layer.local_to_map(player.global_position)
	if randi_range(1, 2) == 1:
		var x_coord = randi_range(0, window_size.x)
		var color_to_use := boss.get_random_color()
		var hit_cells := paint_layer.paint_line_world(Vector2(x_coord, 0), Vector2(x_coord, window_size.y), color_to_use, beam_thickness)
		if player_cell in hit_cells:
			@warning_ignore("integer_division")
			player.modify_health(-impact_damage / (2 if color_to_use == paint_layer.colors[player.color_index] else 1))
	else:
		var y_coord = randi_range(0, window_size.y)
		var color_to_use := boss.get_random_color()
		var hit_cells := paint_layer.paint_line_world(Vector2(0, y_coord), Vector2(window_size.x, y_coord), color_to_use, beam_thickness)
		if player_cell in hit_cells:
			@warning_ignore("integer_division")
			player.modify_health(-impact_damage / (2 if color_to_use == paint_layer.colors[player.color_index] else 1))

	await get_tree().create_timer(1).timeout
	end_attack()
