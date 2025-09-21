extends Area2D
class_name Hitbox

@export var destroy_parent_on_collision: bool = false

var damage: int

#func _ready() -> void:
	#connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(_delta: float) -> void:
	for area in get_overlapping_areas():
		_on_area_entered(area)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		if area.has_method("take_damage"):
			area.take_damage(damage, self)
		if destroy_parent_on_collision:
			get_parent().queue_free()
