shader_type canvas_item;

uniform vec4 color1 : source_color;
uniform vec4 color1_replacement : source_color;
uniform float color1_threshold : hint_range(0.0, 1.0, 0.01);
uniform vec4 color2 : source_color;
uniform vec4 color2_replacement : source_color;
uniform float color2_threshold : hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	if(tex_color.a == 0.0) {
		discard;
	}

	float color1_distance = length(tex_color.rgb - color1.rgb);
	float color2_distance = length(tex_color.rgb - color2.rgb);

	if (color1_distance <= color1_threshold) {
		tex_color = color1_replacement;
	}
	if (color2_distance <= color2_threshold) {
		tex_color = color2_replacement;
	}

	COLOR = tex_color;
}
