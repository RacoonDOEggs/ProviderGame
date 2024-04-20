//AUTEUR : Marc-Olivier Beaulieu
//PROJET : Provider
//NOM DU FICHIER : crashed_plane.gdshader
//DESCRIPTION : Ramplace les couleurs des fenêtres de l'avion en fonction de la vie restante.
shader_type canvas_item;

uniform vec4 oldColor1 : source_color = vec4(0.0, 1.0, 0.0, 1.0);

uniform vec4 newColor1 : source_color;
uniform vec4 newColor2 : source_color = vec4(0.19, 0.18, 0.21, 1.0);
uniform float health = 3;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 inputColor = texture(TEXTURE, UV);
	if (inputColor == oldColor1 && UV.x < (health + 1.0)/5.0){
		COLOR = newColor1;
	}
	else if (inputColor == oldColor1){
		COLOR = newColor2;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
