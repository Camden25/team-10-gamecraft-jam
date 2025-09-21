extends BossAttack

@export var damage: float = 20
@export var slide_back_distance: float = 100.0
@export var slide_back_duration: float = 0.5
@export var charge_speed: float = 1600.0
@export var charge_distance: float = 600.0
@export var should_rotate: bool = true
@export_enum("cyan", "blue", "magenta", "red", "yellow", "green", "black") var projectile_color: String
@export var trail_radius: float = 2.0

var paint_layer: PaintLayer
var charging: bool = false
var charge_direction: Vector2
var charge_target: Vector2
var previous_position: Vector2

# Temporary storage for tween callback
var next_charge_direction: Vector2
var next_charge_target: Vector2

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func _process(delta: float) -> void:
	if charging:
		var move_distance = charge_speed * delta
		var to_target = charge_target - boss.global_position
		
		if to_target.length() <= move_distance:
			boss.global_position = charge_target
			charging = false
			end_attack()
		else:
			boss.global_position += charge_direction * move_distance
			# Paint trail along the movement
			if paint_layer:
				paint_layer.paint_line_world(previous_position, boss.global_position, projectile_color, trail_radius)
			previous_position = boss.global_position

func attack():
	boss.get_node("Hitbox").damage = damage
	
	# Direction to player
	var direction_to_player = (player.global_position - boss.global_position).normalized()
	
	# Slide-back target
	var slide_back_position = boss.global_position - direction_to_player * slide_back_distance
	
	# Optional rotation during slide back
	if should_rotate:
		var rotate_tween = create_tween()
		rotate_tween.tween_property(
			boss, "rotation",
			global_position.angle_to_point(player.global_position),
			slide_back_duration * 0.25
		)
	
	# Slide back tween
	var slide_tween = create_tween()
	slide_tween.tween_property(
		boss, "global_position",
		slide_back_position,
		slide_back_duration
	).set_ease(Tween.EASE_OUT)
	
	# Store charge info for callback
	next_charge_direction = direction_to_player
	next_charge_target = slide_back_position + direction_to_player * charge_distance
	
	# Start charge after slide
	slide_tween.tween_callback(Callable(self, "_start_charge"))

func _start_charge():
	charge_direction = next_charge_direction
	charge_target = next_charge_target
	previous_position = boss.global_position
	charging = true
