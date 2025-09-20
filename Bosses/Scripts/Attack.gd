extends Node2D

class_name BossAttack

@onready var player_manager = get_tree().get_nodes_in_group("Player Manager")[0]
var player = null

@onready var phase = get_parent()
var boss = null

var is_attacking = false

func _process(delta):
	player = player_manager.current_player
	boss = phase.boss

func start_attack():
	is_attacking = true
	attack()

func attack():
	pass

func end_attack():
	is_attacking = false
	phase.attack_complete()
	boss.target_pos = null
