extends Node
class_name MenuManager

signal active_menu_faded

@export var menu_music: AudioStream

var main_menu: PackedScene = preload("res://Menus/Scenes/Main Menu.tscn")
var settings_menu: PackedScene = preload("res://Menus/Scenes/Settings Menu.tscn")
var controls_menu: PackedScene = preload("res://Menus/Scenes/Controls Menu.tscn")
var video_menu: PackedScene = preload("res://Menus/Scenes/Video Menu.tscn")
var audio_menu: PackedScene = preload("res://Menus/Scenes/Audio Menu.tscn")
var quit_menu: PackedScene = preload("res://Menus/Scenes/Quit Menu.tscn")

var target_modulate_alpha: float = 1

@onready var active_menu: Control = main_menu.instantiate()
@onready var scene_manager: SceneManager = get_tree().get_nodes_in_group("SceneManager")[0]

func _ready() -> void:
	add_child(active_menu)
	AudioManager.change_music(menu_music)

func _physics_process(_delta: float) -> void:
	active_menu.modulate.a = lerp(active_menu.modulate.a, float(target_modulate_alpha), 0.2)
	if active_menu.modulate.a <= 0.001 and target_modulate_alpha == 0:
		emit_signal("active_menu_faded")

func swap_active_menu(new_menu: String) -> void:
	target_modulate_alpha = 0
	await active_menu_faded
	active_menu.queue_free()
	active_menu = get(new_menu).instantiate()
	add_child(active_menu)
	active_menu.modulate.a = 0
	target_modulate_alpha = 1
