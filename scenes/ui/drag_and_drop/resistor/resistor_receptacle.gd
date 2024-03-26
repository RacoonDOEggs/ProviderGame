extends DragAndDrop

#0 (x1) Black = #000000
#1 (x10) Brown = #512627
#2 (x100) Red = #cc0000
#3 (x1 000) Orange = #d87347
#4 (x10 000)Yellow = #e6c951
#5 (x100 000)Green = #528f65
#6 (x1 000 000)Blue = #0f5190
#7 (x10 000 000)Violet = #6967ce
#8 (x100 000 000)Grey = #7d7d7d
#9 (x1 000 000 000)White = #ffffff
#  (x0.1)Gold = #c08327
#  (x0.01)Silver = #bfbebf

#Codes de couleur des bandes des résistances
const band_colors = [Color("#000000"), Color("#512627"), Color("#cc0000"), Color("#d87347"), 
Color("#e6c951"), Color("#528f65"), Color("#0f5190"), Color("#6967ce"), Color("#7d7d7d"),
 Color("#ffffff"), Color("#c08327"), Color("#bfbebf")]

@onready var resistor_shader = preload("res://scenes/ui/resistor_receptacle.gdshader")

@export var color1:int = 0
@export var color2:int = 0
@export var color3:int = 0

var is_dragable: bool = true # variable qui détermine si les résistances peuvent être déposés si le joueur a gagné ou non.

#Récupère les couleurs de résistances de l'origine lorsque l'objet est ramassé
func specific_drag_data(data):
	data["origin_color1"] = color1
	data["origin_color2"] = color2
	data["origin_color3"] = color3
	return data

#Initialisation spécifique à cette variation d'un objet drag and drop
func specific_ready():
	if object_id == 1:
		$Label.text = str(object_value)
		$MarginContainer/EditButton.visible = true
		update_resistor_colors()
		update_resistor_value()

#Application du shader des bandes de couleurs à la miniature de glisse
func specific_preview(preview_texture:TextureRect) -> TextureRect:
	preview_texture.material = ShaderMaterial.new()
	preview_texture.material.shader = resistor_shader
	preview_texture.material.set_shader_parameter("newColor1", band_colors[color1])
	preview_texture.material.set_shader_parameter("newColor2", band_colors[color2])
	preview_texture.material.set_shader_parameter("newColor3", band_colors[color3])
	return preview_texture

#Validation spécifique à cette version de l'objet drag and drop
func _can_drop_data(_at_position, data):
	
	return data["origin_group_id"] == group_id and data["origin_texture"] != texture and is_dragable

#Transfert des données spécifiques à cette version de l'objet drag and drop
func update_specific_drop_data(_at_position, data):
	data["origin_node"].get_child(1).text = ""
	data["origin_node"].get_child(2).get_child(0).visible = false
	if object_id == 1:
		$MarginContainer/EditButton.visible = true
		color1 = data["origin_color1"]
		color2 = data["origin_color2"]
		color3 = data["origin_color3"]
		update_resistor_colors()
		update_resistor_value()
	

#Affichage de la fenêtre de modification de résistance
func _on_edit_button_pressed():
	$Window.show()
	update_resistor_colors()

#Fermeture de la fenêtre de modification de résistance
func _on_window_close_requested():
	$Window.hide()
	update_resistor_value()

#Met à jour la valeur écrite sur la résistance
func update_resistor_value():
	if color3 == 10:
		object_value = (color1 * 10 + color2) * pow(10,-1)
	elif color3 == 11:
		object_value = (color1 * 10 + color2) * pow(10,-2)
	else:
		object_value = (color1 * 10 + color2) * pow(10,color3)
	var abb_value:String
	if object_value > 1000000000:
		abb_value = str(object_value/1000000000) + "G"
	elif object_value > 1000000:
		abb_value = str(object_value/1000000) + "M"
	elif object_value > 1000:
		abb_value = str(object_value/1000) + "k"
	else:
		abb_value = str(object_value)
	$Label.text = str(abb_value)

#Met à jour les couleurs des bandes de la résistance
func update_resistor_colors():
	$Window/VBoxContainer/TextureRect.material.set_shader_parameter("newColor1", band_colors[color1])
	$Window/VBoxContainer/TextureRect.material.set_shader_parameter("newColor2", band_colors[color2])
	$Window/VBoxContainer/TextureRect.material.set_shader_parameter("newColor3", band_colors[color3])
	material.set_shader_parameter("newColor1", band_colors[color1])
	material.set_shader_parameter("newColor2", band_colors[color2])
	material.set_shader_parameter("newColor3", band_colors[color3])

#Boutons haut/bas des bandes (mise à jour des compteurs)
func _on_up_1_pressed():
	color1 += 1
	if color1 > 9:
		color1 = 0
	update_resistor_colors()


func _on_up_2_pressed():
	color2 += 1
	if color2 > 9:
		color2 = 0
	update_resistor_colors()


func _on_up_3_pressed():
	color3 += 1
	if color3 > 11:
		color3 = 0
	update_resistor_colors()


func _on_down_1_pressed():
	color1 -= 1
	if color1 < 0:
		color1 = 9
	update_resistor_colors()


func _on_down_2_pressed():
	color2 -= 1
	if color2 < 0:
		color2 = 9
	update_resistor_colors()


func _on_down_3_pressed():
	color3 -= 1
	if color3 < 0:
		color3 = 11
	update_resistor_colors()
