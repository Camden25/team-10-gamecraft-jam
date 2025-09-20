extends Ability

@export var max_dashes = 1
@export var dash_distance = 500
@export var dash_time = 0.2
@export var dash_cooldown = 1

var is_dashing = false

var dash_dir = Vector2()

@onready var dashes_left = max_dashes

func _physics_process(delta):
	set_dash_dir()
	
	if Input.is_action_just_pressed("dash") and dashes_left > 0 and is_dashing == false and player.disabled == false:
		start_dash()
	
	if is_dashing:
		dash(delta)

func set_dash_dir():
	var temp_move_dir = Vector2(int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")), int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up")))
	
	if temp_move_dir != Vector2(0, 0) and not is_dashing:
		dash_dir = temp_move_dir.normalized()

func start_dash():
	print("start dash")
	dashes_left -= 1
	is_dashing = true
	player.next_color()
	player.damage_immune += 1
	dash_timer()

func dash(delta):
	print("dash")
	player.ability_movement += (dash_dir*(dash_distance/dash_time))/delta

func end_dash():
	print("end dash")
	is_dashing = false
	player.damage_immune -= 1
	dash_cooldown_timer()

func dash_timer():
	await get_tree().create_timer(dash_time).timeout
	end_dash()

func dash_cooldown_timer():
	await get_tree().create_timer(dash_cooldown).timeout
	if dashes_left < max_dashes:
		dashes_left += 1
