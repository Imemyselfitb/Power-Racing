shader_type canvas_item;

// TIME works too, but this is for animation Editor
uniform float time : hint_range(0, 3.2);

void vertex() {
	// Called for every vertex the material is visible on.
}

float LERP(float v) {
	float sin_v = sin(v + PI);
	return sqrt(abs(sin_v)) * sign(sin_v);
}

void fragment() {
	vec2 pos = vec2(UV.x / 9.0 * 16.0, UV.y);
	float x = fract(pos.x * 5.0) + 0.5 * (1.0 + LERP(time));
	float y = fract(pos.y * 5.0) + 0.5 * (1.0 + LERP(time));
	float b = abs(step(0.5, x) - step(0.5, y));
	float a = -LERP(time);
	COLOR = vec4(b, b, b, a);
}
