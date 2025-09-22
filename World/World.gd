extends Node2D

@export var music: AudioStream

func _ready() -> void:
	add_to_group("world")
	
	if music:
		AudioManager.change_music(music)
	
	#add_child(color_layer_scene.instantiate())
	#add_child(player_scene.instantiate())
	
	#var boss_instance: Boss = boss_scene.instantiate()
	#add_child(boss_instance)
	#boss_instance.position = Vector2(1000, 500)
