extends BossAttack

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	print("attacking")
	boss.rotation = global_position.angle_to_point(player.global_position)
	
	#paint_layer.paint_circle_world(boss.position, "cyan", 5)
	paint_layer.paint_line_world(boss.global_position, player.global_position, "cyan", randi() % 5, false, true)

	await get_tree().create_timer(1).timeout
	end_attack()
