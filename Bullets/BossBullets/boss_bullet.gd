extends Bullet
class_name BossBullet

var _color: String
var paint_layer: PaintLayer # IF WE DELETE PAINT LAYERS AND REPLACE THEM, CHANGE ME LATER

func _physics_process(_delta):
	super._physics_process(_delta)
	if _color:
		paint_layer.paint_cell_world(global_position, _color);

func set_color(new_color: String):
	_color = new_color
	$ColorRect.material.set_shader_parameter("color1_replacement", Color(paint_layer.color_list[_color][1]))
