extends HealthCharacter
class_name Player

@export var move_speed = 50000
var move_dir := Vector2()

@export var knockback_multiplier = 1
var knockback := Vector2()

@export var damage_invincibility_duration: float = 0.5

var ability_movement := Vector2()

var disabled := false
## Add 1 for each source of damage immunity, remove 1 when no longer immune
## Slightly gross but it works
var damage_immune := 0

var color_index := 0
var can_take_color_damage := true

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

var prev_x_dir: int = 1

@export_category("Damage Flash")
@export var flash_color: Color = Color.WHITE
@export var flash_duration: float = 0.1
@export var flash_count: int = 3  # Number of flashes

func _init() -> void:
	super._init()
	add_to_group("player")

func _ready() -> void:
	var hurtbox = $Hurtbox
	hurtbox.connect("hurt", Callable(self, "_on_hurt"))
	
	$ColorDamageTimer.wait_time = 0.1
	$ColorDamageTimer.one_shot = true 
	$ColorDamageTimer.connect("timeout", Callable(self, "_on_timer_timeout"))
	paint_layer = get_tree().get_first_node_in_group("paint_layer")
	set_color_visual()

func _process(_delta) -> void:
	# Handling for stopping the player going out of the window
	var window_size = get_window().size  # Get current window size
	var half_player_size = Vector2(64, 64)
	
	position.x = clamp(position.x, half_player_size.x, window_size.x - half_player_size.x)
	position.y = clamp(position.y, half_player_size.y, window_size.y - half_player_size.y)
	
	# Color handling
	if can_take_color_damage:
		var color_string := paint_layer.get_color_at_world(position)
		if color_string == "" or color_string == paint_layer.colors[color_index]:
			return
		
		can_take_color_damage = false
		if color_string == "black":
			modify_health(-2)
		else:
			modify_health(-1)
		$ColorDamageTimer.start()

func _physics_process(delta) -> void:
	if disabled:
		return
	
	get_input()
	
	if ability_movement != Vector2(0, 0):
		move_dir = Vector2(0, 0)
	
	velocity = (move_dir*move_speed + knockback*knockback_multiplier + ability_movement) * delta
	
	if move_dir.x != 0 and sign(move_dir.x) != sign(prev_x_dir):
		sprite_flip()
	@warning_ignore("incompatible_ternary")
	prev_x_dir = move_dir.x if move_dir.x != 0 else prev_x_dir
	
	move_dir = Vector2(0, 0)
	ability_movement = Vector2(0, 0)
	
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

#func swap_in() -> void:
	#disabled = false
	#visible = true
	#$Hurtbox/CollisionShape2D.disabled = false
#
#func swap_out() -> void:
	#disabled = true
	#visible = false
	#$Hurtbox/CollisionShape2D.disabled = true

func modify_health(modify_amount: int) -> void:
	if modify_amount < 0 and damage_immune > 0:
		return

	super.modify_health(modify_amount)

func death_check() -> void:
	super.death_check()
	$HealthLabelTEMP.text = "%d" % get_health()

func swap_color(new_color: String) -> void:
	color_index = paint_layer.colors.find(new_color)
	set_color_visual()

func next_color() -> void:
	color_index += 1
	if color_index > 5:
		color_index = 0
	set_color_visual()

func set_color_visual() -> void:
	$SpriteFlipping/Sprite2D.material.set_shader_parameter("color1_replacement", Color(paint_layer.color_list[paint_layer.colors[color_index]][0]))
	$SpriteFlipping/Sprite2D.material.set_shader_parameter("color2_replacement", Color(paint_layer.color_list[paint_layer.colors[color_index]][1]))

func sprite_flip():
	var tween = create_tween()
	tween.tween_property($SpriteFlipping, "scale", Vector2(sign(move_dir).x, 1), 0.1)

func _on_hurt(damage: int, source: Node) -> void:
	modify_health(-damage)
	print("Ouch! Took", damage, "damage from", source)
	$Hurtbox/CollisionShape2D.disabled = true
	flash_sprite_multiple(flash_count)
	await get_tree().create_timer(damage_invincibility_duration).timeout
	$Hurtbox/CollisionShape2D.disabled = false

func flash_sprite_multiple(times: int) -> void:
	var tween = create_tween()
	
	# Start from the current modulate
	var normal_color = Color(1, 1, 1, 1)
	var color_toggle = true
	
	for i in range(times * 2):  # Multiply by 2 because each flash has on and off
		var target_color = flash_color if color_toggle else normal_color
		tween.tween_property($SpriteFlipping/Sprite2D, "modulate", target_color, flash_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		color_toggle = !color_toggle
