extends Control

var menu_open: bool = false

@onready var scene_manager: SceneManager = get_tree().get_nodes_in_group("SceneManager")[0]

func _process(_delta: float) -> void:
	menu_open = visible
	if menu_open == false and get_tree().paused == false:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().paused = true
			visible = true
	if menu_open == true:
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
			get_tree().paused = false


func _on_resume_button_pressed() -> void:
	if menu_open == true:
		visible = false
		get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	scene_manager.swap_scene(scene_manager.menu_manager_scene)
