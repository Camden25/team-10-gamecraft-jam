extends Area2D

@export var damage = 1
@export var can_be_stunned = true

@onready var boss = get_parent()

func stun(stun_time):
	print("stunned")
