extends BossAttack

var going_down := false
@export var speed: float = 0.035
@export var splash_radius: float = 9.5

var ending_location: Vector2

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func _process(delta):
	if going_down:
		boss.position = boss.position.lerp(ending_location, (speed * delta)**0.3)
		if boss.position.y + 50 >= ending_location.y:
			stop_landing()

func attack():
	going_down = true
	boss.in_air = false
	ending_location = Vector2(boss.position.x, boss.position.y + 2000)

	await get_tree().create_timer(1).timeout
	end_attack()

func stop_landing():
	going_down = false
	boss.position = ending_location
	paint_layer.paint_circle_world(boss.global_position, boss.get_random_color(), splash_radius)

func can_use() -> bool:
	if !boss.in_air:
		return false
	return true