extends BossAttack

@export var projectile_count = 10
@export var splash_radius = 5
@export var impact_damage = 20

@export var single_color: bool = false
@export_enum("cyan", "blue", "magenta", "red", "yellow", "green", "black") var projectile_color: String 

var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

const projectile_drop = preload("res://Misc/ProjectileDrop.tscn")

func _ready() -> void:
	paint_layer = get_tree().get_first_node_in_group("paint_layer")

func attack():
	var cells: Array[Vector2i] = paint_layer.get_all_tiles()
	for i: int in range(projectile_count):
		var chosen_cell := cells[randi_range(0, cells.size() - 1)]
		var drop_instance: ProjectileDrop = projectile_drop.instantiate()
		var proper_location := paint_layer.map_to_local(chosen_cell)
		
		drop_instance.global_position = proper_location
		drop_instance.paint_layer = paint_layer
		drop_instance.splash_size = splash_radius
		drop_instance.initial_wait = i*0.2 + 0.3
		drop_instance.impact_damage = impact_damage
		
		if single_color:
			drop_instance.set_color(projectile_color)
		else:
			drop_instance.set_color(boss.get_random_color())
		
		get_tree().root.add_child(drop_instance)

	await get_tree().create_timer(1).timeout
	end_attack()

func can_use() -> bool:
	return true
