shader_type canvas_item;

uniform sampler2D overlay_texture;
uniform vec2 texture_scale = vec2(1.0, 1.0); // the tilemap and overlay texture are the same scale

void fragment() {
	vec4 tilemap_colour = texture(TEXTURE, UV);
	float tilemap_alpha = tilemap_colour.a;

	vec2 overlay_uv = UV * texture_scale;
	vec4 overlay_colour = texture(overlay_texture, overlay_uv);
	overlay_colour.a = tilemap_alpha;
	COLOR = overlay_colour;
}