extends CanvasLayer

@export var generator_progress_bar: WFC2DGenerator
var last_value: float = 0

signal end_progress

func _process(_delta):
	# La valeur de progression du chargement.
	%TextureProgressBar.value = generator_progress_bar.get_progress()
	
	# Si la valeur de progression a changé, on avance l'avion.
	if %TextureProgressBar.value != last_value:
		
		# On avance l'avion selon la différence des 2 dernières valeurs de progression.
		%Plane2d.position.x -= (%TextureProgressBar.value - last_value) * 1000
		last_value = %TextureProgressBar.value # On enregistre l'ancienne valeur de progression.
		
		#Si le chargement est terminé, on commence l'animation de l'avion.
	elif %TextureProgressBar.value == 1: 
		end_progress.emit()
		$AnimationPlayer.play("Plane_destroy") 
		Globals.player_speed = 500 # Le joueur peut se déplacer à nouveau.

# Lorsque l'animation est terminée, on supprime l'avion.
func _on_animation_player_animation_finished(anim_name):
	$".".queue_free()
	$AnimationPlayer.stop()
