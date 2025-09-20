extends TileMapLayer
class_name PaintLayer

@export var colors: Array[String] = ["cyan", "blue", "magenta", "red", "yellow", "green", "black"]

var primaries: Array[String] = ["cyan", "magenta", "yellow"]
var secondaries: Array[String] = ["blue", "red", "green"]
var secondary_map: Dictionary = {
	"blue": ["cyan","magenta"],
	"red": ["magenta","yellow"],
	"green": ["cyan","yellow"]
}

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

func paint_circle_world(world_pos: Vector2, color: String, radius: float) -> void:
	var cell := local_to_map(world_pos)
	for cell2: Vector2i in get_points_in_circle(cell, radius):
		paint_cell(cell2, color)

func paint_square_world(world_pos: Vector2, color: String, radius: int) -> void:
	var cell := local_to_map(world_pos)
	for cell2: Vector2i in get_points_in_square(cell, radius):
		paint_cell(cell2, color)

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
