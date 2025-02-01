shader_type canvas_item;

uniform float time : hint_range(0.0, 1.0);

void fragment() {
	COLOR.a = 1.0 - step(1.0 - time, sin(UV.x * PI) * sin(UV.y * PI));
}
