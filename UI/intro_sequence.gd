extends Control

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().get_first_node_in_group("SceneManager").swap_scene(load("res://World/Scenes/Bossfight1.tscn"))
