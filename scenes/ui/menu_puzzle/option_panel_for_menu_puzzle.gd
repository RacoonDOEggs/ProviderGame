extends CanvasLayer

signal red_but_pressed

func _ready():
	Globals.puzzles_done.connect(_on_puzzles_done)

# Signal reçu et émis lorsqu'on clique sur quitter dans le menu option du menu des casse-têtes.
func _on_exit_but_pressed():
	visible = false # On ferme le menu d'option du menu des casse-têtes.

# Signal reçu lorsque tous les casse-têtes on été complété.
func _on_menu_puzzle_ui_all_puzzle_win():
	$Big_red_button/Electrical_but.disabled = false # On active le gros bouton rouge qui termine le jeu

# Lorsqu'on appuie sur le gros bouton rouge, le jeu prend fin.
func _on_red_but_pressed():
	Globals.game_won.emit()
	visible = false
	red_but_pressed.emit()

# Si tous les casse-têtes sont complétés, on ouvre le bouton rouge pour finir le jeu.
func _on_puzzles_done():
	$Big_red_button/Red_but.disabled = false
