extends CanvasLayer

func _ready():
	var i = -1
	# Appel de la fonction récursive
	enable_visible_characters(i)

# Fonction récursive qui fait apparaître successivement les 3 points après le mot chargement.
func enable_visible_characters( i : int):
	%Point.set_visible_characters(i)
	await get_tree().create_timer(0.5).timeout
	if i < 4:
		await get_tree().create_timer(0.5).timeout
		enable_visible_characters(i + 1)
	else:
		i = -1
		enable_visible_characters(i)


# En reçevant se signal, on supprime l'écran d'attente.
func _on_progress_bar_wait_screen_destroy_wait_screen():
	$".".queue_free()
