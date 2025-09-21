extends TileMapLayer
class_name PaintLayer

@export var colors: Array[String] = ["cyan", "blue", "magenta", "red", "yellow", "green", "black"]
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
	"black" : ["1b192a", "83838a"]
}

var tile_array: Array[Vector2i] = []

func _ready() -> void:
	add_to_group("paint_layer")
	
	await get_tree().create_timer(1).timeout
	
	paint_cell(Vector2(60, 33), "magenta")
	"""
	for x in range(120):
		for y in range(67):
			if (x-60)**2 + (y-33)**2 <= 100:
				paint_cell(Vector2(x,y), "cyan")
	
	for x in range(120):
		for y in range(67):
			if (x-85)**2 + (y-33)**2 <= 400:
				paint_cell(Vector2(x,y), "yellow")
	
	for x in range(120):
		for y in range(67):
			if (x-30)**2 + (y-10)**2 <= 900:
				paint_cell(Vector2(x,y), "magenta")
	
	for x in range(120):
		for y in range(67):
			if (x-45)**2 + (y-50)**2 <= 600:
				paint_cell(Vector2(x,y), "yellow")
				"""

	paint_circle_world(Vector2(300, 300), colors[1], 5)

	paint_square_world(Vector2(500, 700), colors[3], 8)
	paint_square_world(Vector2(600, 800), colors[5], 8)
	
	#for i in range(6):
		#for y in range(4):
			#paint_cell(Vector2i(i, y), colors[i])
	#
	#for i in range(3):
		#for x in range(6):
			#paint_cell(Vector2i(x, i+1), colors[2*i])

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
	set_cell(cell, 0, Vector2i(-1, 0))

func paint_circle_world(world_pos: Vector2, color: String, radius: float) -> void:
	var cell := local_to_map(world_pos)
	for cell2: Vector2i in get_points_in_circle(cell, radius):
		paint_cell(cell2, color)

func paint_square_world(world_pos: Vector2, color: String, radius: int) -> void:
	var cell := local_to_map(world_pos)
	for cell2: Vector2i in get_points_in_square(cell, radius):
		paint_cell(cell2, color)

func paint_line_world(start_pos: Vector2, end_pos: Vector2, color: String, radius: float) -> void:
	for cell: Vector2i in get_points_in_line(local_to_map(start_pos), local_to_map(end_pos)):
		if radius > 1:
			for cell2: Vector2i in get_points_in_circle(cell, radius):
				paint_cell(cell2, color)
		else:
			paint_cell(cell, color)

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

func get_points_in_circle(cell: Vector2i, radius: float) -> Array:
	var points = []
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

func get_points_in_square(cell: Vector2i, radius: int) -> Array:
	var points = []
	var min_x = int(floor(cell.x - radius))
	var max_x = int(floor(cell.x + radius))
	var min_y = int(floor(cell.y - radius))
	var max_y = int(floor(cell.y + radius))

	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			points.append(Vector2i(x, y))
	
	return points

func paint_cell_world(world_pos: Vector2, color: String) -> void:
	var cell := local_to_map(world_pos)
	paint_cell(cell, color)

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
		var window_size = get_window().size
		for i in range(window_size.x / tile_set.tile_size.x):
			for j in range(window_size.y / tile_set.tile_size.y):
				tile_array.append(Vector2i(i, j))
	
	return tile_array
