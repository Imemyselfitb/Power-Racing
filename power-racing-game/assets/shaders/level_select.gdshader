shader_type canvas_item;

uniform float time : hint_range(0.0, 1.0);

void fragment() {
	if (sin(UV.x * PI) * sin(UV.y * PI) < time) {
		COLOR.a = 0.0;
	}
}
