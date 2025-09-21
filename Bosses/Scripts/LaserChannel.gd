extends BossAttack

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

@export var beam_length: int = 1000
@export var beam_radius: float = 1.5
@export var splash_radius: float = 7
@export var impact_damage: int = 20
@export var splash_damage: int = 30

const direction_array := [0, 90, 180, 270]

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	var color_to_use := boss.get_random_color()
	var pillars: Array[Node] = get_tree().get_nodes_in_group("pillar")
	var pillar_to_use: Pillar = pillars[randi_range(0, pillars.size() - 1)]
	var player_cell := paint_layer.local_to_map(player.global_position)
	var player_hit := false

	var hit_cells := paint_layer.paint_circle_world(pillar_to_use.global_position, color_to_use, splash_radius)
	if player_cell in hit_cells:
		player_hit = true
		@warning_ignore("integer_division")
		player.modify_health(-splash_damage / (2 if color_to_use == paint_layer.colors[player.color_index] else 1))

	for direction in direction_array:
		var hit_tiles := paint_layer.paint_line_world(pillar_to_use.global_position, get_position_at_distance(pillar_to_use.global_position, direction, beam_length), color_to_use, beam_radius, true, true)
		if !player_hit and (player_cell in hit_tiles):
			@warning_ignore("integer_division")
			player.modify_health(-impact_damage / (2 if color_to_use == paint_layer.colors[player.color_index] else 1))
			player_hit = true

	await get_tree().create_timer(1).timeout
	end_attack()

func get_position_at_distance(start_position: Vector2, angle_degrees: float, distance: float) -> Vector2:
	# Convert degrees to radians
	var angle_radians = deg_to_rad(angle_degrees)
	# Create a direction vector from the angle
	var direction = Vector2(cos(angle_radians), sin(angle_radians))
	# Calculate the new position by adding the scaled direction to the start position
	return start_position + direction * distance
