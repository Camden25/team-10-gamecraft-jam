extends Control

@export var music: AudioStream

func _ready():
	AudioManager.change_music(music)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().get_first_node_in_group("SceneManager").swap_scene(load("res://World/Scenes/Bossfight1.tscn"))
