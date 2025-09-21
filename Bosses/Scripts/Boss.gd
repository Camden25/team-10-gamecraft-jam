extends HealthCharacter

class_name Boss

@export var phases = 1
var current_phase_num = 0
var active_phase: BossPhase

var waiting_for_new_phase = false

var can_attack = false
var attacking = false
var in_air := false # I don't like doing this for a single boss but such is life in a gamejam

@export var move_speed = 450
@export var knockback_multiplier = 1

var target_pos = null

var move_dir = Vector2()
var knockback = Vector2()
var ability_movement = Vector2()

@export var colors: Array[String] = []

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
	set_max_health(active_phase.phase_health)
	set_health(active_phase.phase_health)
	can_attack = true

func death():
	print("dead")
	queue_free()

func _on_hurtbox_area_entered(area):
	pass

func get_random_color() -> String:
	if colors.size() == 0:
		return "black"

	return colors[randi_range(0, colors.size() - 1)]
