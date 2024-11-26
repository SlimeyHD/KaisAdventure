shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR.rgb = vec3(1.0, 1.0, 1.0);
}