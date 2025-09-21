extends Ability

@export var damage = 10
@export var cooldown = 0.15

var can_attack = true

@onready var attack_scene = preload("res://Bullets/PlayerBullets/PlayerBullet.tscn")

func _process(_delta):
	if Input.is_action_pressed("attack_1") and can_attack and player.disabled == false:
		attack()

func attack():
	can_attack = false
	var attack_instance = attack_scene.instantiate()
	attack_instance.damage = damage #* player.damage_modifier
	attack_instance.rotation_angle = global_position.angle_to_point(get_global_mouse_position())
	attack_instance.global_position = $ProjectileSpawn.global_position
	attack_instance.get_node("Sprite2D").material.set_shader_parameter("color1_replacement", Color(player.paint_layer.color_list[player.paint_layer.colors[player.color_index]][0]))
	
	# change this line
	get_tree().get_nodes_in_group("world")[0].add_child(attack_instance)
	player.get_node("PlayerShoot").play()
	
	await get_tree().create_timer(cooldown).timeout
	can_attack = true
