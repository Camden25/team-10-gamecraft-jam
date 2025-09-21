extends Node2D

class_name BossAttack

#@onready var phase = get_parent()
#@onready var boss = phase.boss
var phase: BossPhase
var boss: Boss
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_attacking = false

func post_init() -> void:
	phase = get_parent()
	boss = phase.boss

func _process(delta):
	pass

func start_attack():
	is_attacking = true
	
	animation_player.play("Telegraph")
	await animation_player.animation_finished
	animation_player.play("Attack")
	
	attack()

func attack():
	pass

func end_attack():
	is_attacking = false
	animation_player.play("End")
	await animation_player.animation_finished
	phase.attack_complete()
	boss.target_pos = null
