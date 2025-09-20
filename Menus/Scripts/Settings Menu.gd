extends Control

func _on_back_button_pressed() -> void:
	get_parent().call("swap_active_menu", "main_menu")

func _on_controls_button_pressed() -> void:
	get_parent().call("swap_active_menu", "controls_menu")

func _on_video_button_pressed() -> void:
	get_parent().call("swap_active_menu", "video_menu")

func _on_audio_button_pressed() -> void:
	get_parent().call("swap_active_menu", "audio_menu")
