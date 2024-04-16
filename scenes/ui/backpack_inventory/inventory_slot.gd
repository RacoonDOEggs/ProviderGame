#AUTEUR : Marc-Olivier Beaulieu
#PROJET : Provider
#NOM DU FICHIER : inventory_slot.gd
#DESCRIPTION : Version modifiée de drag_and_drop.gd propre aux cases de l'inventaire.
extends DragAndDrop

#Bool pour savoir si on peut déposer un item à cet endroit
func _can_drop_data(_at_position, _data):
	return object_id == -1

#Ajout au dictionnaire des données spécifiques à cette application
func update_specific_drop_data(_at_position, data):
	update_stack_label()
	data["origin_node"].update_stack_label()

#Mise à jour du compteur d'items de la case
func update_stack_label():
	$Label.text = str(object_value) if object_value > 0 else "" 
