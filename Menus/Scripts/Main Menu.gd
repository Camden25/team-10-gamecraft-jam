extends Control

func _on_start_button_pressed() -> void:
	get_parent().scene_manager.swap_scene(load("res://World/Scenes/Submarine.tscn"))

func _on_settings_button_pressed() -> void:
	get_parent().call("swap_active_menu", "settings_menu")

func _on_quit_button_pressed() -> void:
	get_parent().call("swap_active_menu", "quit_menu")
	
func _on_start_button_mouse_entered() -> void:
	$StartButton.scale = Vector2(1.1, 1.1)

func _on_start_button_mouse_exited() -> void:
	$StartButton.scale = Vector2(1, 1)

func _on_settings_button_mouse_entered() -> void:
	$SettingsButton.scale = Vector2(1.1, 1.1)

func _on_settings_button_mouse_exited() -> void:
	$SettingsButton.scale = Vector2(1, 1)

func _on_quit_button_mouse_entered() -> void:
	$QuitButton.scale = Vector2(1.1, 1.1)

func _on_quit_button_mouse_exited() -> void:
	$QuitButton.scale = Vector2(1, 1)
