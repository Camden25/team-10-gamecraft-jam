extends Node2D
class_name BaseScene

#@onready var scene_manager_scene: PackedScene = load("res://RootNodes/SceneManager.tscn")
@onready var player_scene: PackedScene = load("res://Player/Player.tscn")
@onready var boss_scene: PackedScene = load("res://Bosses/Scenes/Boss.tscn")
@onready var color_layer_scene: PackedScene = load("res://Paint/Scenes/PaintLayer.tscn")
@onready var pillar_scene: PackedScene = load("res://Misc/Pillar.tscn")

func _ready() -> void:
	add_to_group("world")
	
	add_child(color_layer_scene.instantiate())
	add_child(player_scene.instantiate())

	var boss_instance: Boss = boss_scene.instantiate()
	add_child(boss_instance)
	boss_instance.position = Vector2(1000, 500)

	var pillar_instance: Pillar = pillar_scene.instantiate()
	add_child(pillar_instance)
	pillar_instance.global_position = Vector2(500, 500)

	pillar_instance = pillar_scene.instantiate()
	add_child(pillar_instance)
	pillar_instance.global_position = Vector2(500, 800)