extends HealthCharacter
class_name Boss

@export var next_scene: String

@export var boss_name: String

@export var phases = 1
var current_phase_num = 0
var active_phase: BossPhase

var waiting_for_new_phase = false

var can_attack = false
var attacking = false
var in_air := false # I don't like doing this for a single boss but such is life in a gamejam

@export var move_speed = 450
@export var knockback_multiplier = 1

@export var contact_damage: int = 10

var target_pos = null

var move_dir = Vector2()
var knockback = Vector2()
var ability_movement = Vector2()

@export_flags("cyan", "blue", "magenta", "red", "yellow", "green", "black") var colors
enum color_list {cyan, blue, magenta, red, yellow, green, black}

@export_group("Sprite Flipping")
@export var flip_sprite: bool
@export var sprite_starts_flipped: bool
@export var flip_cooldown: float = 0.5
@export var flip_threshold: float = 100
var can_flip: bool = true

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var ui: UI = get_tree().get_first_node_in_group("ui")

func _ready():
	var hurtbox = $Hurtbox
	hurtbox.connect("hurt", Callable(self, "_on_hurt"))
	
	ui.boss_name = boss_name
	
	add_to_group("boss")
	randomize()
	waiting_for_new_phase = true

func _process(_delta):
	if can_attack and waiting_for_new_phase == false:
		active_phase.choose_attack()
	if waiting_for_new_phase and attacking == false:
		phase_transition(current_phase_num+1)
	
	if attacking == false:
		sprite_flipping()
		$Hitbox.damage = contact_damage

func _physics_process(_delta):
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
	ui.boss_max_health = get_max_health()
	ui.boss_health = get_health()
	can_attack = true

func death():
	queue_free()
	
	get_tree().get_first_node_in_group("SceneManager").swap_scene(load(next_scene))

func _on_hurt(damage: int, source: Node) -> void:
	set_health(get_health() - damage)
	ui.boss_health = get_health()
	print("Ouch! Took ", damage, " damage from ", source)

func get_random_color() -> String:
	var selected: Array[int] = []
	for i in color_list.values():
		if colors & (1 << i): # use bitshift here when checking
			selected.append(i)
	
	if selected.is_empty():
		return "black"
	
	return color_list.keys()[selected.pick_random()]

func sprite_flipping() -> void:
	var facing_dir: int
	if $SpriteFlipping.scale.x == 1:
		facing_dir = 1
	if $SpriteFlipping.scale.x == -1:
		facing_dir = -1
	
	var tween = create_tween()
	
	if can_flip and flip_sprite and abs(global_position.x - player.global_position.x) >= flip_threshold:
		if (global_position.x > player.global_position.x and facing_dir == 1) or (global_position.x < player.global_position.x and facing_dir == -1):
			#$SpriteFlipping.scale = Vector2(facing_dir*-1, 1)
			tween.tween_property($SpriteFlipping, "scale", Vector2(facing_dir*-1, 1), 0.3)
