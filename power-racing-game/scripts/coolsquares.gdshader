shader_type canvas_item;
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
void fragment() {
	COLOR.rgb = hsv2rgb(vec3(TIME * 0.1, 0.4, 1));
	if ((cos((TIME * 2.0) + UV.x * 40.0) * sin((TIME * 5.0) + UV.y * 40.0)) + sin(UV.y * PI) * 3.0 > 2.0) {
		COLOR.rgb /= 1.5;
	}
}
