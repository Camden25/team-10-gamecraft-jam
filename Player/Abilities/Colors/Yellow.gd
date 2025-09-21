extends ColorAbility

@export var duration := 2.0
@export var circle_radius := 5.0

var is_enabled := false

func attack():
	start_cooldown()
	is_enabled = true
	await get_tree().create_timer(duration).timeout
	is_enabled = false

func _process(delta):
	super._process(delta)
	if !is_enabled:
		return
	
	paint_layer.paint_circle_world(player.global_position, "yellow", circle_radius)
