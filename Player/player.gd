extends CharacterBody2D
class_name Player

@export var move_speed = 500
var move_dir = Vector2()

@export var knockback_multiplier = 1
var knockback = Vector2()

var disabled = false;

func _ready() -> void:
	add_to_group("player")

func _process(delta):
	pass

func _physics_process(delta):
	if disabled:
		return

	get_input()
	
	velocity = move_dir*move_speed + knockback*knockback_multiplier
	
	move_dir = Vector2(0, 0)
	
	move_and_slide()

func get_input():
	set_move_dir()

func set_move_dir():
	move_dir.x += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	move_dir.y += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	move_dir = move_dir.normalized()

func knockback_taken(area, knockback_amount):
	knockback = global_position.direction_to(area.global_position) * knockback_amount

func swap_in():
	disabled = false
	visible = true
	$Hurtbox/CollisionShape2D.disabled = false

func swap_out():
	disabled = true
	visible = false
	$Hurtbox/CollisionShape2D.disabled = true
