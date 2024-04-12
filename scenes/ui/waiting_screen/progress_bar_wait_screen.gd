extends CanvasLayer

@export var generator_progress_bar: WFC2DGenerator
var last_value: float = 0

signal destroy_wait_screen

func _ready():
	pass

func _process(delta):
	# La valeur de progression du chargement.
	%TextureProgressBar.value = generator_progress_bar.get_progress()
	
	# Si la valeur de progression a changé, on avance l'avion.
	if %TextureProgressBar.value != last_value:
		
		# On avance l'avion selon la différence des 2 dernières valeurs de progression.
		%Plane2d.position.x -= (%TextureProgressBar.value - last_value) * 1000
		last_value = %TextureProgressBar.value # On enregistre l'ancienne valeur de progression.
		
		#Si le chargement est terminé, on retire l'écran d'attente.
	elif %TextureProgressBar.value == 1: 
		destroy_wait_screen.emit()
		$".".queue_free() # On retire l'avion.
