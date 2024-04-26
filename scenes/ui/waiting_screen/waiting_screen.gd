extends CanvasLayer

func _ready():
	var i = -1
	enable_visible_characters(i) # Appel fonction récursive.

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

# Lorsque la progression est terminée, on commence l'animation de l'écran d'attente..
func _on_progress_bar_wait_screen_end_progress():
	$AnimationPlayer.play("Waiting_screen_disapear")

# Lorsque l'animation est terminée, on supprime l'écran d'attente.
func _on_animation_player_animation_finished(anim_name):
	$".".queue_free()
	$AnimationPlayer.stop()
