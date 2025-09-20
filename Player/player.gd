extends CharacterBody2D
class_name Player

@export var move_speed = 50000
var move_dir = Vector2()

@export var knockback_multiplier = 1
var knockback = Vector2()

var disabled = false

var color_index = -1

func _ready() -> void:
	add_to_group("player")

func _process(delta) -> void:
	var window_size = get_window().size  # Get current window size
	var half_player_size = Vector2(10, 10)  # Adjust based on player sprite size/2

	position.x = clamp(position.x, half_player_size.x, window_size.x - half_player_size.x)
	position.y = clamp(position.y, half_player_size.y, window_size.y - half_player_size.y)
	pass

func _physics_process(delta) -> void:
	if disabled:
		return

	get_input()
	
	velocity = (move_dir*move_speed + knockback*knockback_multiplier) * delta
	
	move_dir = Vector2(0, 0)
	
	move_and_slide()

func get_input() -> void:
	set_move_dir()

func set_move_dir() -> void:
	move_dir.x += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	move_dir.y += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	move_dir = move_dir.normalized()

func knockback_taken(area, knockback_amount) -> void:
	knockback = global_position.direction_to(area.global_position) * knockback_amount

func swap_in() -> void:
	disabled = false
	visible = true
	$Hurtbox/CollisionShape2D.disabled = false

func swap_out() -> void:
	disabled = true
	visible = false
	$Hurtbox/CollisionShape2D.disabled = true
