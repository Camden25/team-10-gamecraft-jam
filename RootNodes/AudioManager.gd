extends Node

func _process(_delta: float) -> void:
	for i in get_node("SFX").get_children():
		if i.playing == false:
			i.queue_free()

func clear_sfx() -> void:
	for i in get_node("SFX").get_children():
		i.queue_free()

func sound_effect(stream_name: String, volume_offset: float = 0) -> void:
	var stream_player_instance: AudioStreamPlayer = AudioStreamPlayer.new()
	stream_player_instance.stream = load("res://Audio/SoundEffects/" + stream_name)
	stream_player_instance.bus = "SFX"
	stream_player_instance.volume_db = volume_offset
	get_node("SFX").add_child(stream_player_instance)
	stream_player_instance.play()

func change_music(new_track: AudioStream) -> void:
	if $Music/Main.stream != new_track:
		if $Music/Main.stream != null:
			$AudioTransitions.play("FadeOut")
			await $AudioTransitions.animation_finished
		$Music/Main.stream = new_track
		$AudioTransitions.play("FadeIn")
