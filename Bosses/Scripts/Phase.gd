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

func _ready() -> void:
	for attack: BossAttack in get_children(true):
		attack.post_init()

func choose_attack():
	boss.can_attack = false
	boss.attacking = true
	var valid_attacks: Array = []
	for i in range(get_child_count()):
		var node: Node2D = get_child(i)
		if node.can_use():
			valid_attacks.append(node)

	active_attack = valid_attacks[randi_range(0, valid_attacks.size() - 1)]
	if active_attack != prev_attack or valid_attacks.size() == 1:
		prev_attack = active_attack
		active_attack.start_attack()
	else:
		choose_attack()

func attack_complete():
	boss.attacking = false
	await get_tree().create_timer(attack_cooldown).timeout
	if boss.current_phase_num == phase_number:
		boss.can_attack = true
