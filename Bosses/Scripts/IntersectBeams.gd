extends BossAttack

@export var beam_thickness: float = 1.5
@export var intersection_count: int = 1
@export var impact_damage: int = 20
@export var double_impact_damage: int = 35

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	var window_size := get_window().size
	for i in range(intersection_count):
		var x_coord := randi_range(0, window_size.x)
		var y_coord := randi_range(0, window_size.y)
		var player_cell := paint_layer.local_to_map(player.global_position)

		var laser1_color := boss.get_random_color()
		var laser2_color := boss.get_random_color()

		var laser1_hits := paint_layer.paint_line_world(Vector2(x_coord, 0), Vector2(x_coord, window_size.y), laser1_color, beam_thickness)
		var laser2_hits := paint_layer.paint_line_world(Vector2(0, y_coord), Vector2(window_size.x, y_coord), laser2_color, beam_thickness)

		var player_hit_laser1 := false
		var player_hit_laser2 := false
		if player_cell in laser1_hits:
			player_hit_laser1 = true
		
		if player_cell in laser2_hits:
			player_hit_laser2 = true
		
		if player_hit_laser1 or player_hit_laser2:
			if player_hit_laser1 and player_hit_laser2:
				player.modify_health(-double_impact_damage) # Getting hit by both ignores any damage reductions
			elif player_hit_laser1:
				@warning_ignore("integer_division")
				player.modify_health(-impact_damage / (2 if laser1_color == paint_layer.colors[player.color_index] else 1))
			elif player_hit_laser2:
				@warning_ignore("integer_division")
				player.modify_health(-impact_damage / (2 if laser2_color == paint_layer.colors[player.color_index] else 1))

	await get_tree().create_timer(1).timeout
	end_attack()

