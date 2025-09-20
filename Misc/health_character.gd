extends CharacterBody2D
class_name HealthCharacter

signal on_death

@export var max_health := 100
var health: int
var dead: bool = false

func _init() -> void:
    health = max_health

func modify_health(modify_amount: int) -> void:
    health = clamp(health + modify_amount, 0, max_health)
    death_check()

func set_health(new_health: int) -> void:
    health = clamp(new_health, 0, max_health)
    death_check()

func death_check() -> void:
    if dead:
        return

    if health <= 0:
        dead = true
        on_death.emit()