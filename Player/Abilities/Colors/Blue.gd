extends ColorAbility

@export var deviation_degrees := 25.0
@export var max_range := 425
@export var line_radius := 2.5

func attack():
	var end_positions := compute_aim_lines(player.global_position, get_viewport().get_mouse_position())
	var cell_positions: Array[Vector2i] = []
	for target_pos in end_positions:
		paint_layer.paint_line_world(player.global_position, target_pos, "blue", line_radius)
		cell_positions.append(paint_layer.local_to_map(target_pos))
	
	deal_boss_damage(cell_positions, damage)
	start_cooldown()

func compute_aim_lines(player_pos: Vector2, mouse_pos: Vector2) -> Array:
	var to_mouse: Vector2 = mouse_pos - player_pos
	var dist: float = to_mouse.length()
	if dist == 0:
		return []  # No direction if mouse is at player position
	
	var effective_length: float = min(dist, max_range)
	var direction: Vector2 = to_mouse.normalized()
	
	var straight_end: Vector2 = player_pos + direction * effective_length
	
	var left_dir: Vector2 = direction.rotated(deg_to_rad(deviation_degrees))
	var left_end: Vector2 = player_pos + left_dir * effective_length
	
	var right_dir: Vector2 = direction.rotated(deg_to_rad(-deviation_degrees))
	var right_end: Vector2 = player_pos + right_dir * effective_length
	
	return [straight_end, left_end, right_end]