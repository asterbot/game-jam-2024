shader_type canvas_item;

uniform vec3 colour: source_color = vec3(1);
uniform float progress: hint_range(0.0, 1.0, 0.1) = 0;

void fragment() {
	vec4 curr_colour = texture(TEXTURE, UV);
	float curr_alpha = curr_colour.a;
	vec4 to_colour = vec4(colour, curr_alpha);
	vec4 target_colour = mix(curr_colour, to_colour, progress);
	COLOR = target_colour;
}
