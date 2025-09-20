extends Area2D
class_name Hitbox

var damage: int

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		if area.has_method("take_damage"):
			area.take_damage(damage, $Hitbox)
