extends ColorAbility

@export var triangle_width := 200.0
@export var triangle_height := 700.0

func attack():
	var triangle_cells := get_isosceles_triangle_cells(paint_layer, player.global_position, triangle_width, triangle_height)
	for cell: Vector2i in triangle_cells:
		paint_layer.paint_cell(cell, "cyan")
	
	deal_boss_damage(triangle_cells, damage)

	start_cooldown()

func get_isosceles_triangle_cells(tilemap: TileMapLayer, user_pos: Vector2, base_width: float, height: float) -> Array[Vector2i]:
	# Get mouse position in world coordinates
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos = tilemap.get_viewport_transform().affine_inverse() * mouse_pos
	
	# Convert user position to tilemap coordinates
	var user_cell = tilemap.local_to_map(user_pos)
	
	# Calculate direction vector from user to mouse
	var direction = (mouse_pos - user_pos).normalized()
	
	# Array to store cells in the triangle
	var triangle_cells: Array[Vector2i] = []
	
	# Convert height and base width to tile units
	var tile_size = tilemap.tile_set.tile_size.x
	var max_height_tiles = int(height / tile_size)
	var half_base_tiles = int(base_width / (2 * tile_size))
	
	# Rotate 90 degrees to get perpendicular vector for base
	var perp_direction = Vector2(-direction.y, direction.x)
	
	# Iterate over a bounding box around the user position
	for x in range(-half_base_tiles - max_height_tiles, half_base_tiles + max_height_tiles + 1):
		for y in range(-max_height_tiles, max_height_tiles + 1):
			var cell = user_cell + Vector2i(x, y)
			var cell_world_pos = tilemap.map_to_local(cell)
			
			# Convert cell position to local coordinates relative to user
			var local_pos = cell_world_pos - user_pos
			
			# Project onto direction and perpendicular axes
			var dist_along = local_pos.dot(direction)
			var dist_perp = abs(local_pos.dot(perp_direction))
			
			# Check if cell is within the isosceles triangle
			if dist_along >= 0 and dist_along <= height:
				# Calculate max allowed perpendicular distance at this height
				var max_perp = (1.0 - dist_along / height) * (base_width / 2)
				if dist_perp <= max_perp:
					triangle_cells.append(cell)
	
	return triangle_cells