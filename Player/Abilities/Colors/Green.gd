extends ColorAbility

@export var self_splash_radius := 5.5
@export var laser_radius := 2
@export var beam_max_length := 575
@export var end_splash_radius := 8

func attack():
	var has_damaged_boss := deal_boss_damage(paint_layer.paint_circle_world(player.global_position, "green", self_splash_radius), damage)
	var painted_cells := paint_layer.paint_line_world(player.global_position, get_clamped_mouse_position(player.global_position, get_viewport().get_mouse_position(), beam_max_length), "green", laser_radius, false, true)
	if !has_damaged_boss:
		has_damaged_boss = deal_boss_damage(painted_cells, damage)
	var end_painted_cells := paint_layer.paint_circle_world(paint_layer.map_to_local(painted_cells[painted_cells.size() - 1]), "green", end_splash_radius)
	if !has_damaged_boss:
		deal_boss_damage(end_painted_cells, damage)
	start_cooldown()

func get_clamped_mouse_position(start_pos: Vector2, mouse_pos: Vector2, max_length: float) -> Vector2:
	var direction = (mouse_pos - start_pos).normalized()
	var distance = min(start_pos.distance_to(mouse_pos), max_length)
	return start_pos + direction * distance