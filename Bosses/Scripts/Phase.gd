extends Node2D

class_name BossPhase

@export var boss_path: NodePath

@export var phase_number = 1
@export var phase_health = 50
@export var attack_cooldown = 3

@export var avoid_previous_attack = true
var prev_attack = null

var active_attack: BossAttack

@onready var boss = get_node(boss_path)

func choose_attack():
	boss.can_attack = false
	boss.attacking = true
	active_attack = get_child(randi_range(0, get_child_count()-1))
	if active_attack != prev_attack:
		prev_attack = active_attack
		active_attack.start_attack()
	else:
		choose_attack()

func attack_complete():
	boss.attacking = false
	await get_tree().create_timer(attack_cooldown).timeout
	if boss.current_phase_num == phase_number:
		boss.can_attack = true
