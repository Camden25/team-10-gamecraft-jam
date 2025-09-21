extends TileMapLayer
class_name PaintLayer

@export var colors: Array[String] = ["cyan", "blue", "magenta", "red", "yellow", "green", "black", "white"]
@export var black_decay_time: float = 5.0

var primaries: Array[String] = ["cyan", "magenta", "yellow"]
var secondaries: Array[String] = ["blue", "red", "green"]
var secondary_map: Dictionary = {
	"blue": ["cyan","magenta"],
	"red": ["magenta","yellow"],
	"green": ["cyan","yellow"]
}

var color_list := {
	"cyan" : ["35cbc8", "99dace"],
	"blue" : ["403e85", "9a9eb8"],
	"magenta" : ["d757b7", "d99bb8"],
	"red" : ["b3133b", "b26d7e"],
	"yellow" : ["ffdb85", "f7dfc3"],
	"green" : ["54bc54", "afd4a8"],
	"black" : ["1b192a", "83838a"],
	"white" : ["b1b1b9", "b1b1b9"]
}

var tile_array: Array[Vector2i] = []

func _ready() -> void:
	add_to_group("paint_layer")
	
	#await get_tree().create_timer(1).timeout
	#
	#paint_cell(Vector2(60, 33), "magenta")
#
	#paint_circle_world(Vector2(300, 300), colors[1], 5)
#
	#paint_square_world(Vector2(500, 700), colors[3], 8)
	#paint_square_world(Vector2(600, 800), colors[5], 8)
	
func paint_cell(cell: Vector2i, color: String) -> void:
	var current_cell_color := get_color_at_cell(cell)
	if current_cell_color != "":
		#print("Location: ", cell, "  Old color: ", current_cell_color, "  Mixed color: ", color, "  New color: ", mix_colors(current_cell_color, color))
		color = mix_colors(current_cell_color, color)
	
	var tile_id := colors.find(color)
	if tile_id != -1:
		set_cell(cell, 0, Vector2i(tile_id, 0))
		if color == "black":
			reset_black_tile(cell)

func reset_black_tile(cell: Vector2i):
	await get_tree().create_timer(black_decay_time).timeout
	if get_color_at_cell(cell) != "black":
		return
		
	set_cell(cell, 0, Vector2i(-1, 0))

func paint_circle_world(world_pos: Vector2, color: String, radius: float) -> Array[Vector2i]:
	var cell := local_to_map(world_pos)
	var points := get_points_in_circle(cell, radius)
	for cell2: Vector2i in points:
		paint_cell(cell2, color)
	return points

func paint_square_world(world_pos: Vector2, color: String, radius: int) -> Array[Vector2i]:
	var cell := local_to_map(world_pos)
	var points := get_points_in_square(cell, radius)
	for cell2: Vector2i in points:
		paint_cell(cell2, color)
	return points

func paint_line_world(start_pos: Vector2, end_pos: Vector2, color: String, radius: float, ignore_pillars: bool = false, ignore_boss: bool = false) -> Array[Vector2i]:
	var already_painted_cells: Array[Vector2i] = []
	var points := get_points_in_line(local_to_map(start_pos), local_to_map(end_pos))
	for cell: Vector2i in points:
		if !ignore_pillars and are_pillars_in_range(map_to_local(cell), 16):
			break

		if !ignore_boss and is_boss_in_range(map_to_local(cell), 16):
			break

		if radius > 1:
			for cell2: Vector2i in get_points_in_circle(cell, radius):
				if cell2 in already_painted_cells:
					continue
					
				paint_cell(cell2, color)
				already_painted_cells.append(cell2)
		else:
			if cell in already_painted_cells:
				continue

			paint_cell(cell, color)
			already_painted_cells.append(cell)
	return points

func are_pillars_in_range(target_pos: Vector2, pillar_range: float) -> bool:
	for pillar in get_tree().get_nodes_in_group("pillar"):
		if pillar.global_position.distance_to(target_pos) <= pillar_range:
			return true
	return false

func is_boss_in_range(target_pos: Vector2, boss_range: float) -> bool:
	for boss in get_tree().get_nodes_in_group("boss"):
		if boss.global_position.distance_to(target_pos) <= boss_range:
			return true
	return false

## Using Bresenham line algorithm for this
func get_points_in_line(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	var points: Array[Vector2i] = []
	
	var x0 = start.x
	var y0 = start.y
	var x1 = end.x
	var y1 = end.y
	
	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)
	var sx = 1 if x0 < x1 else -1
	var sy = 1 if y0 < y1 else -1
	var err = dx - dy
	
	# Always include the start point
	points.append(Vector2i(x0, y0))
	
	while x0 != x1 or y0 != y1:
		var err2 = err * 2
		if err2 > -dy:
			err -= dy
			x0 += sx
		if err2 < dx:
			err += dx
			y0 += sy
		points.append(Vector2i(x0, y0))
	
	return points

func get_points_in_circle(cell: Vector2i, radius: float) -> Array[Vector2i]:
	var points: Array[Vector2i] = []
	var min_x = int(floor(cell.x - radius))
	var max_x = int(floor(cell.x + radius))
	var min_y = int(floor(cell.y - radius))
	var max_y = int(floor(cell.y + radius))

	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			var point = Vector2i(x, y)
			if cell.distance_to(point) <= radius:
				points.append(point)
	
	return points

func get_points_in_square(cell: Vector2i, radius: int) -> Array[Vector2i]:
	var points: Array[Vector2i] = []
	var min_x = int(floor(cell.x - radius))
	var max_x = int(floor(cell.x + radius))
	var min_y = int(floor(cell.y - radius))
	var max_y = int(floor(cell.y + radius))

	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			points.append(Vector2i(x, y))
	
	return points

func paint_cell_world(world_pos: Vector2, color: String) -> Vector2i:
	var cell := local_to_map(world_pos)
	paint_cell(cell, color)
	return cell

func get_color_at_cell(cell: Vector2i) -> String:
	var tile_id := get_cell_atlas_coords(cell).x
	if tile_id == -1:
		return "" # no tile present
	return colors[tile_id]

func get_color_at_world(world_pos: Vector2) -> String:
	var cell := local_to_map(world_pos)
	return get_color_at_cell(cell)

func mix_colors(color_a: String, color_b: String) -> String:
	# same color -> stays the same
	if color_a == color_b:
		return color_a
	
	# two primaries -> secondary
	if color_a in primaries and color_b in primaries:
		for secondary_color in secondary_map.keys():
			var components = secondary_map[secondary_color]
			if color_a in components and color_b in components:
				return secondary_color
		return "black" # fallback
	
	# secondary + primary
	if color_a in secondaries and color_b in primaries:
		return color_b if color_b in secondary_map[color_a] else "black"
	
	if color_b in secondaries and color_a in primaries:
		return color_a if color_a in secondary_map[color_b] else "black"
	
	# two secondaries -> black
	if color_a in secondaries and color_b in secondaries:
		return "black"
	
	return "black" # fallback

func get_all_tiles() -> Array:
	if !tile_array.size():
		var top_left: Vector2 = get_tree().get_first_node_in_group("top_left").global_position
		var bottom_right: Vector2 = get_tree().get_first_node_in_group("bottom_right").global_position
		
		for i in range((bottom_right.x - top_left.x) / tile_set.tile_size.x):
			for j in range((bottom_right.y - top_left.y) / tile_set.tile_size.y):

				tile_array.append(Vector2i(i, j))
	
	return tile_array
