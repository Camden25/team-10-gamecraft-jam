extends HealthCharacter
class_name Player

@export var move_speed = 50000
var move_dir := Vector2()

@export var knockback_multiplier = 1
var knockback := Vector2()

var disabled := false

var color_index := 0
var can_take_color_damage := true

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	add_to_group("player")
	$ColorDamageTimer.wait_time = 0.1
	$ColorDamageTimer.one_shot = true 
	$ColorDamageTimer.connect("timeout", Callable(self, "_on_timer_timeout"))
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func _process(delta) -> void:
	# Handling for stopping the player going out of the window
	var window_size = get_window().size  # Get current window size
	var half_player_size = Vector2(10, 10)  # Adjust based on player sprite size/2

	position.x = clamp(position.x, half_player_size.x, window_size.x - half_player_size.x)
	position.y = clamp(position.y, half_player_size.y, window_size.y - half_player_size.y)

	# Color handling
	if can_take_color_damage:
		var color_string := paint_layer.get_color_at_world(position)
		if color_string == "" or color_string == paint_layer.colors[color_index]:
			return
		
		can_take_color_damage = false
		modify_health(-1)
		$ColorDamageTimer.start()

func _physics_process(delta) -> void:
	if disabled:
		return

	get_input()
	
	velocity = (move_dir*move_speed + knockback*knockback_multiplier) * delta
	
	move_dir = Vector2(0, 0)
	
	move_and_slide()

func _on_timer_timeout() -> void:
	can_take_color_damage = true

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

func death_check() -> void:
	super.death_check()
	$HealthLabelTEMP.text = "%d" % get_health()