extends Node2D

@onready var player_scene: PackedScene = load("res://Player/Player.tscn")
@export var boss_scene: PackedScene = load("res://Bosses/Boss2/Boss2.tscn")
@onready var color_layer_scene: PackedScene = load("res://Paint/Scenes/PaintLayer.tscn")

func _ready() -> void:
	add_to_group("world")
	
	#add_child(color_layer_scene.instantiate())
	#add_child(player_scene.instantiate())
	
	#var boss_instance: Boss = boss_scene.instantiate()
	#add_child(boss_instance)
	#boss_instance.position = Vector2(1000, 500)
