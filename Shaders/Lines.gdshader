shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR.rgb = color.rgb - (sin(TIME) + 1.0)/4.0;
}