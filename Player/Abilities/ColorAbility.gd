extends Ability
class_name ColorAbility

## have a child node for each color and do the attacks through those. This action is just for managing them

@export var hold_time = 0.0
@export var cooldown = 4

var holding_attack = false
var current_hold_time := 0.0
var can_attack = true

@onready var paint_layer: PaintLayer = get_tree().get_first_node_in_group("paint_layer")

func _ready() -> void:
	set_process(true)

func _process(delta):
	if !can_attack:
		return

	if Input.is_action_just_pressed("attack_2") and can_attack and player.disabled == false:
		holding_attack = true
	
	if holding_attack:
		if current_hold_time >= hold_time:
			attack()
		elif Input.is_action_pressed("attack_2"):
			current_hold_time += delta
		else:
			holding_attack = false
			current_hold_time = 0

func attack():
	# trigger the attack in the specific child for the current player color
	pass

func start_cooldown():
	can_attack = false
	holding_attack = false
	current_hold_time = 0
	await get_tree().create_timer(cooldown).timeout
	can_attack = true

func deal_boss_damage(cell_array: Array[Vector2i], damage: int):
	for boss in get_tree().get_nodes_in_group("boss"):
		if paint_layer.local_to_map(boss.global_position) in cell_array:
			boss.modify_health(-damage)
		
