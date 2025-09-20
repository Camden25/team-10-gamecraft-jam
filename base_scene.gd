extends Node2D
class_name BaseScene

#@onready var scene_manager_scene: PackedScene = load("res://RootNodes/SceneManager.tscn")
@onready var player_scene: PackedScene = load("res://Player/Player.tscn")
@onready var boss_scene: PackedScene = load("res://Bosses/Scenes/Boss.tscn")

func _ready() -> void:
    #add_child(scene_manager_scene.instantiate())
    add_child(player_scene.instantiate())
    var boss_instance: Boss = boss_scene.instantiate()
    add_child(boss_instance)
    boss_instance.position = Vector2(100, 100)