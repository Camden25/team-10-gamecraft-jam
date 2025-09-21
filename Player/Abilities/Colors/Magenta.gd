extends ColorAbility

@export var cone_angle := 120.0
@export var cone_range := 250.0

func attack():
	var cells_hit := get_cone_cells(paint_layer, player.global_position)
	for cell: Vector2i in cells_hit:
		paint_layer.paint_cell(cell, "magenta")

	deal_boss_damage(cells_hit, damage)
	start_cooldown()

func get_cone_cells(tilemap: TileMapLayer, start_pos: Vector2) -> Array[Vector2i]:
	# Get mouse position in world coordinates
	var mouse_pos = get_viewport().get_mouse_position()
	mouse_pos = tilemap.get_viewport_transform().affine_inverse() * mouse_pos
	
	# Convert start position to tilemap coordinates
	var start_cell = tilemap.local_to_map(start_pos)
	
	# Calculate direction vector from start position to mouse
	var direction = (mouse_pos - start_pos).normalized()
	
	# Array to store cells in the cone
	var cone_cells: Array[Vector2i] = []
	
	# Convert cone range to tile units (assuming square tiles)
	var max_range = int(cone_range / tilemap.tile_set.tile_size.x)
	
	# Iterate through a square bounding box around the start cell
	for x in range(-max_range, max_range + 1):
		for y in range(-max_range, max_range + 1):
			var cell = start_cell + Vector2i(x, y)
			
			# Get world position of the cell's center
			var cell_world_pos = tilemap.map_to_local(cell)
			
			# Calculate vector from start to cell
			var cell_vector = cell_world_pos - start_pos
			
			# Check if cell is within range
			if cell_vector.length() <= cone_range:
				# Calculate angle between direction and cell vector
				var angle_to_cell = direction.angle_to(cell_vector)
				
				# Check if cell is within the cone angle
				if abs(angle_to_cell) <= deg_to_rad(cone_angle / 2):
					cone_cells.append(cell)
	
	return cone_cells
