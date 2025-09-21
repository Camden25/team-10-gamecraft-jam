extends BossAttack

@export var bullet_count: int = 8
@export var damage: int = 20
@onready var attack_scene = preload("res://Bullets/BossBullets/BossBullet.tscn")

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	var window_size := get_window().size
	var start_pos: Vector2
	var end_pos: Vector2
	for i in range(bullet_count):
		if randi_range(1, 2) == 1:
			var x_coord = randi_range(0, window_size.x)
			start_pos = Vector2(x_coord, 0)
			end_pos = Vector2(x_coord, window_size.y)
		else:
			var y_coord = randi_range(0, window_size.y)
			start_pos = Vector2(0, y_coord)
			end_pos = Vector2(window_size.x, y_coord)

		var attack_instance: BossBullet = attack_scene.instantiate()
		attack_instance.damage = damage
		attack_instance.global_position = start_pos
		attack_instance.paint_layer = paint_layer
		attack_instance.set_color(boss.get_random_color())
		attack_instance.rotation_angle = start_pos.angle_to_point(end_pos)
		
		# change this line
		get_tree().get_nodes_in_group("world")[0].add_child(attack_instance)

	await get_tree().create_timer(1).timeout
	end_attack()

