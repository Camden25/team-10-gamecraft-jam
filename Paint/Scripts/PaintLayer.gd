extends TileMapLayer
class_name PaintLayer

@export var colors: Array[String] = ["red", "orange", "yellow", "green", "blue", "purple", "black"]

var primaries: Array[String] = ["red", "yellow", "blue"]
var secondaries: Array[String] = ["orange", "green", "purple"]
var secondary_map: Dictionary = {
	"orange": ["red","yellow"],
	"green": ["yellow","blue"],
	"purple": ["red","blue"]
}

func _ready() -> void:
	add_to_group("paint_layer")
	for i in range(6):
		for y in range(4):
			paint_cell(Vector2i(i, y), colors[i])
	
	for i in range(3):
		for x in range(6):
			paint_cell(Vector2i(x, i+1), colors[2*i])

func paint_cell(cell: Vector2i, color: String) -> void:
	var current_cell_color := get_color_at_cell(cell)
	if current_cell_color != "":
		print("Location: ", cell, "  Old color: ", current_cell_color, "  Mixed color: ", color, "  New color: ", mix_colors(current_cell_color, color))
		color = mix_colors(current_cell_color, color)
	
	var tile_id := colors.find(color)
	if tile_id != -1:
		set_cell(cell, 0, Vector2i(tile_id, 0))

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
