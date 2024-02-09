shader_type canvas_item;

uniform vec4 oldColor1 : source_color;
uniform vec4 oldColor2 : source_color;
uniform vec4 oldColor3 : source_color;

uniform vec4 newColor1 : source_color;
uniform vec4 newColor2 : source_color;
uniform vec4 newColor3 : source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 inputColor = texture(TEXTURE, UV);
	
	if (inputColor == oldColor1){
		COLOR = newColor1;
	}
	else if (inputColor == oldColor2){
		COLOR = newColor2;
	}
	else if (inputColor == oldColor3){
		COLOR = newColor3;
	}
	else{
		COLOR = inputColor;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
