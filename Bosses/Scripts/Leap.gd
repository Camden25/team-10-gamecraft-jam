extends BossAttack

var going_up := false
@export var speed: float = 0.035

var ending_location: Vector2

func _process(delta):
	if going_up:
		boss.position = boss.position.lerp(ending_location, (speed * delta)**0.5)
		if boss.position.y < ending_location.y + 150:
			stop_leaping()

func attack():
	going_up = true
	boss.in_air = true
	ending_location = Vector2(boss.position.x, boss.position.y - 2000)

	await get_tree().create_timer(1).timeout
	end_attack()

func stop_leaping():
	going_up = false
	boss.position = ending_location