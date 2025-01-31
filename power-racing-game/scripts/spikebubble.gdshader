shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (sin(TIME * 15.0) + sin(UV.x * PI) * sin(UV.y * PI) > 0.0){
		COLOR.a *= 10000.0;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
