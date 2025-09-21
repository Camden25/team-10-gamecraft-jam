extends Node2D

class_name BossPhase

@export var boss_path: NodePath
@export var animation_player: AnimationPlayer

@export var phase_number: int = 1
@export var phase_health: int = 50
@export var attack_cooldown: float = 3

@export var avoid_previous_attack = true
var prev_attack = null

var active_attack: BossAttack

@onready var boss = get_node(boss_path)

func _ready() -> void:
	for attack: BossAttack in get_children(true):
		attack.post_init()

func choose_attack():
	boss.can_attack = false
	boss.attacking = true
	var child_count = get_child_count()
	active_attack = get_child(randi_range(0, child_count)-1)
	if active_attack != prev_attack or child_count == 1:
		prev_attack = active_attack
		animation_player.play("Attacking")
		active_attack.start_attack()
	else:
		choose_attack()

func attack_complete():
	boss.attacking = false
	animation_player.play("Idle")
	await get_tree().create_timer(attack_cooldown).timeout
	if boss.current_phase_num == phase_number:
		boss.can_attack = true
