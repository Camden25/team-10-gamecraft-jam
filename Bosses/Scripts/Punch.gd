extends BossAttack

func attack():
	print("attacking")
	boss.rotation = global_position.angle_to_point(player.global_position)
	await get_tree().create_timer(1).timeout
	end_attack()
