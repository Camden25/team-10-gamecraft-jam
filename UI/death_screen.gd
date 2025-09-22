extends CanvasLayer

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	
	var scene_manager: SceneManager = get_tree().get_first_node_in_group("SceneManager")
	
	scene_manager.swap_scene(scene_manager.previous_scene)
