extends Control

func _on_back_button_pressed() -> void:
	get_parent().call("swap_active_menu", "settings_menu")
