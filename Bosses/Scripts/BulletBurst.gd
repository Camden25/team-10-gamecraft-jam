extends BossAttack

@export var damage: int = 20
@onready var attack_scene = preload("res://Bullets/BossBullets/BossBullet.tscn")

const direction_array := [0, 45, 90, 135, 180, 225, 270, 315]

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	print("The boss is winding up!")
	await get_tree().create_timer(1).timeout
	for direction: int in direction_array:
		var attack_instance: BossBullet = attack_scene.instantiate()
		attack_instance.damage = damage
		attack_instance.global_position = boss.global_position
		attack_instance.paint_layer = paint_layer
		attack_instance.set_color(boss.get_random_color())
		attack_instance.rotation_angle = deg_to_rad(direction)
		get_tree().get_nodes_in_group("world")[0].add_child(attack_instance)

	await get_tree().create_timer(1).timeout
	end_attack()
