shader_type canvas_item;

const float speed = 2.5;
const float colorIntensity = 0.2;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR.r = color.r - ((sin(TIME * speed)) + 1.0) * colorIntensity;
	//COLOR.g = color.g - ((sin(TIME * speed)) + 1.0) * colorIntensity;
	//COLOR.b = color.b - ((sin(TIME * speed)) + 1.0) * colorIntensity;
}