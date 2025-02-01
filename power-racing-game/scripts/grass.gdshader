shader_type spatial;
uniform vec4 albedo : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = albedo.rgb;
	ALBEDO += 0.1 * abs(sin(UV.x * TIME + TIME + sin(UV.y * TIME)) + sin((UV.y + UV.x) * TAU + TIME * 0.8));
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
