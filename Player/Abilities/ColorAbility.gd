extends Ability

## have a child node for each color and do the attacks through those. This action is just for managing them

@export var hold_time = 0.25
@export var cooldown = 4

var holding_attack = false
var current_hold_time = 0
var can_attack = true

@onready var attack_scene = preload("res://Bullets/PlayerBullets/PlayerBullet.tscn")

func _process(delta):
	if Input.is_action_just_pressed("attack_1") and can_attack and player.disabled == false:
		holding_attack = true
	
	if holding_attack:
		if current_hold_time >= hold_time:
			attack()
		elif Input.is_action_pressed("attack_1"):
			current_hold_time += delta
		else:
			holding_attack = false
			current_hold_time = 0

func attack():
	# trigger the attack in the specific child for the current player color
	pass
