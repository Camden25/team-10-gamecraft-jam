extends Control

@export var music: AudioStream

func _ready():
	AudioManager.change_music(music)
