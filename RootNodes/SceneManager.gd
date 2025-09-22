extends Node
class_name SceneManager

var current_scene: Node
var current_scene_packed: PackedScene
var previous_scene: PackedScene

@onready var scene: PackedScene = load("res://UI/IntroSequence.tscn")

func _ready() -> void:
	current_scene_packed = scene
	previous_scene = scene
	var scene_instance = scene.instantiate()
	add_child(scene_instance)
	current_scene = scene_instance


#func _process(delta: float) -> void:
	#if SaveSystem.current_save != 0 and SaveSystem.current_save != null:
		#CurrentSaveData.playtime += delta


func swap_scene(new_scene: PackedScene) -> void:
	previous_scene = current_scene_packed
	current_scene_packed = new_scene
	var new_scene_instance: Node = new_scene.instantiate()
	remove_child(current_scene)
	call_deferred("add_child", new_scene_instance)
	await new_scene_instance.tree_entered
	current_scene = new_scene_instance
