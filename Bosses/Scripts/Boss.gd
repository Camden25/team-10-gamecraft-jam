extends CharacterBody2D

class_name Boss

@export var phases = 1
var current_phase_num = 0
var active_phase: BossPhase

var waiting_for_new_phase = false

var can_attack = false
var attacking = false

var max_health = 10
var health = 10

@export var move_speed = 450
@export var knockback_multiplier = 1

var target_pos = null

var move_dir = Vector2()
var knockback = Vector2()
var ability_movement = Vector2()

func _ready():
	add_to_group("boss")
	randomize()
	waiting_for_new_phase = true

func _process(delta):
	if can_attack and waiting_for_new_phase == false:
		active_phase.choose_attack()
	if waiting_for_new_phase and attacking == false:
		phase_transition(current_phase_num+1)

func _physics_process(delta):
	if target_pos != null:
		move_dir = global_position.direction_to(target_pos)
	else:
		move_dir = Vector2(0, 0)
	
	if ability_movement != Vector2(0, 0):
		move_dir = Vector2(0, 0)
	
	velocity = move_dir*move_speed + knockback*knockback_multiplier + ability_movement
	
	move_dir = Vector2(0, 0)
	knockback = Vector2(0, 0)
	ability_movement = Vector2(0, 0)
	
	move_and_slide()

func phase_transition(phase):
	waiting_for_new_phase = false
	can_attack = false
	current_phase_num = phase
	$PhaseTransitions.play(str(phase))
	await $PhaseTransitions.animation_finished
	active_phase = $Phases.get_children()[phase-1]
	max_health = active_phase.phase_health
	health = max_health
	can_attack = true

func damage_taken(damage):
	print("damage taken: " + str(damage))
	health -= damage
	print("health remaining: " + str(health))
	if health <= 0:
		if current_phase_num < phases:
			waiting_for_new_phase = true
		else:
			death()

func death():
	print("dead")
	queue_free()

func _on_hurtbox_area_entered(area):
	damage_taken(area.damage)
