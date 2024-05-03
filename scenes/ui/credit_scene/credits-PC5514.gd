#AUTEUR :  Xavier Bilodeau
#PROJET : Provider
#NOM DU FICHIER : credits.gd
#DESCRIPTION : Scène des crédits du jeu (auteurs).
extends CanvasLayer

var status: bool = true # Variable indiquant si on doit arrêter le défilement.

# Si le joueur pèse sur n'importe quel bouton, ça ferme les crédits.
func _unhandled_input(event):
	$".".visible = false
	$Control/ScrollContainer.scroll_vertical = 0
	status = false	

# Fonction qui fait défiler les crédits.
func credits_progress():
	while status == true:
		await get_tree().create_timer(0.005).timeout
		$Control/ScrollContainer.scroll_vertical += 2

# Quand on clique sur le bouton crédit, on l'affiche et on commence le défilement.
func _on_main_menu_credit_opened():
	$".".visible = true
	print("opened")
	status = true
	credits_progress()
