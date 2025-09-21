extends CharacterBody2D
class_name Bullet

@export var move_speed = 1000
@export var despawn_time = 0.75
@export var damping = 1
@export var target_physics_layer: int

var damage = 0
var rotation_angle = 0

@onready var speed = move_speed

func _ready() -> void:
	$Hitbox.collision_mask = target_physics_layer
	$Hitbox.damage = damage
	rotation = rotation_angle
	wait_for_destroy()
	add_to_group("Bullets")

func _physics_process(_delta):
	velocity = Vector2(speed, 0).rotated(rotation_angle)
	speed *= damping
	move_and_slide()

func wait_for_destroy():
	await get_tree().create_timer(despawn_time).timeout
	queue_free()
