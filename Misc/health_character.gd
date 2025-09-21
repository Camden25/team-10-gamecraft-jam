extends CharacterBody2D
class_name HealthCharacter

signal on_death

@export var _max_health := 100
var _health: int
var dead: bool = false

func _init() -> void:
	_health = _max_health

func modify_health(modify_amount: int) -> void:
	_health = clamp(_health + modify_amount, 0, _max_health)
	death_check()

func set_health(new_health: int) -> void:
	_health = clamp(new_health, 0, _max_health)
	death_check()

func get_health() -> int:
	return _health

func set_max_health(new_max_health: int) -> void:
	_max_health = new_max_health
	_health = clamp(_health, 0, _max_health)

func get_max_health() -> int:
	return _max_health

func death_check() -> void:
	if dead:
		return
	
	if _health <= 0:
		dead = true
		on_death.emit()
		death()

func death() -> void:
	pass
