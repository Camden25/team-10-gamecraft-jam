extends BossAttack

@export var slide_back_distance: float = 100.0
@export var slide_back_duration: float = 0.5
@export var charge_speed: float = 1600.0
@export var charge_distance: float = 600.0

@export var rotate: bool = true

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	# Get direction away from player (for sliding back)
	var direction_to_player = (player.global_position - boss.global_position).normalized()
	var slide_back_position = boss.global_position - direction_to_player * slide_back_distance
	
	# Create tween for smooth movement
	var tween = create_tween()
	
	# Slide back
	if rotate:
		tween.tween_property(boss, "rotation", global_position.angle_to_point(player.global_position), slide_back_duration * 0.25)
	tween.tween_property(boss, "global_position", slide_back_position, slide_back_duration * 0.75).set_ease(Tween.EASE_OUT)
	
	# Charge towards player after sliding back
	var end_position: Vector2 = boss.global_position + direction_to_player * charge_distance
	tween.tween_property(boss, "global_position", end_position, 
		boss.global_position.distance_to(end_position) / charge_speed).set_delay(slide_back_duration)

	await get_tree().create_timer(1).timeout
	end_attack()


func get_opposite_angle(angle: float) -> float:
	var opposite_angle = angle + PI
	if opposite_angle > PI:
		opposite_angle -= 2 * PI
	elif opposite_angle < -PI:
		opposite_angle += 2 * PI
	return opposite_angle
