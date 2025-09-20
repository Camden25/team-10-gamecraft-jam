extends Area2D
class_name Hurtbox

signal hurt(damage: int, source: Node)

func _ready():
	add_to_group("hurtbox")

func take_damage(damage: int, source: Node) -> void:
	emit_signal("hurt", damage, source)
