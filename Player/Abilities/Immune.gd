extends Ability

@export var max_immunes = 1
@export var immune_time = 1
@export var immune_cooldown = 1

@onready var immunes_left = max_immunes

var is_immune := false

func _physics_process(delta):
	if Input.is_action_just_pressed("immune") and !is_immune and !player.disabled:
		start_immune()

func start_immune():
	is_immune = true
	immunes_left -= 1
	player.damage_immune += 1
	immune_timer()

func end_immune():
	var color_string: String = player.paint_layer.get_color_at_world(player.global_position)
	if color_string != "black" and color_string != "":
		player.swap_color(color_string)
	is_immune = false
	player.damage_immune -= 1
	immune_cooldown_timer()

func immune_timer():
	await get_tree().create_timer(immune_time).timeout
	end_immune()

func immune_cooldown_timer():
	await get_tree().create_timer(immune_cooldown).timeout
	if immunes_left < max_immunes:
		immunes_left += 1
