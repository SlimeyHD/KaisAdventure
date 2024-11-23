shader_type canvas_item;

const float speed = 2.5;
const float colorIntensity = 0.375;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR.rgb = color.rgb - ((sin(TIME * speed)) + 1.0) * colorIntensity;
}