extends Node2D
class_name ProjectileDrop

var ready_to_move := false
@onready var ending_location := Vector2($DropSprite.position.x, $DropSprite.position.y)
var original_y: float
var _color: String
var paint_layer: PaintLayer

@export var speed: float = 0.1
@export var start_height: int = 1500
var splash_size: float = 1


func _ready() -> void:
	animate_drop()

func animate_drop():
	original_y = $DropSprite.position.y
	$DropSprite.position = Vector2($DropSprite.position.x, $DropSprite.position.y - start_height)
	#$DropSprite.modulate = Color(0, 0, 0)
	ready_to_move = true

func _process(delta: float) -> void:
	if ready_to_move:
		$DropSprite.position = $DropSprite.position.lerp(ending_location, (speed * delta)**0.5)
		#$DropSprite.modulate = $DropSprite.modulate.lerp(Color(1, 1, 1), (speed * delta)**0.5)
		
	if $DropSprite.position.y + 50 >= original_y:
		on_land()

func on_land():
	queue_free()
	paint_layer.paint_circle_world(global_position, _color, splash_size)

func set_color(new_color: String) -> void:
	_color = new_color
	$DropSprite.material.set_shader_parameter("color1_replacement", Color(paint_layer.color_list[_color][0]))
	$DropSprite.material.set_shader_parameter("color2_replacement", Color(paint_layer.color_list[_color][1]))