extends Control

func _on_yes_button_pressed() -> void:
	get_tree().quit()

func _on_no_button_pressed() -> void:
	get_parent().call("swap_active_menu", "main_menu")
