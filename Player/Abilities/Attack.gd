extends Ability

@export var damage = 10
@export var cooldown = 0.15

var can_attack = true

@onready var attack_scene = preload("res://Bullets/PlayerBullets/PlayerBullet.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("attack_1") and can_attack and player.disabled == false:
		attack()

func attack():
	can_attack = false
	var attack_instance = attack_scene.instantiate()
	attack_instance.damage = damage #* player.damage_modifier
	attack_instance.rotation_angle = global_position.angle_to_point(get_global_mouse_position())
	attack_instance.global_position = player.global_position
	
	# change this line
	get_tree().get_nodes_in_group("world")[0].add_child(attack_instance)
	
	await get_tree().create_timer(cooldown).timeout
	can_attack = true
