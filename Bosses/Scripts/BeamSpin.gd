extends BossAttack

@export var damage: int = 20
@export var beam_length: int = 800
@export var beam_radius: float = 2
@export var impact_damage: int = 15
@export_enum("cyan", "blue", "magenta", "red", "yellow", "green", "black") var force_color: String 

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	var color_to_use: String
	if force_color:
		color_to_use = force_color
	else:
		color_to_use = boss.get_random_color()
	var start_degree = randi_range(0, 36) * 10
	var player_cell := paint_layer.local_to_map(player.global_position)
	for i in range(1, 37):
		var hit_cells := paint_layer.paint_line_world(boss.position, get_position_at_distance(boss.position, i * 10 + start_degree, beam_length), color_to_use, beam_radius, false, true)
		if player_cell in hit_cells:
			@warning_ignore("integer_division")
			player.modify_health(-impact_damage / (2 if color_to_use == paint_layer.colors[player.color_index] else 1))
		await get_tree().create_timer(0.05).timeout

	await get_tree().create_timer(1).timeout
	end_attack()

func get_position_at_distance(start_position: Vector2, angle_degrees: float, distance: float) -> Vector2:
	# Convert degrees to radians
	var angle_radians = deg_to_rad(angle_degrees)
	# Create a direction vector from the angle
	var direction = Vector2(cos(angle_radians), sin(angle_radians))
	# Calculate the new position by adding the scaled direction to the start position
	return start_position + direction * distance
