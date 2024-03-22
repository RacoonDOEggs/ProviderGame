#Source pour l'implémentation du laser et des mirroirs : https://www.youtube.com/watch?v=Mgk5eAvzo8k&t=629s
extends StaticBody2D

signal win()

var max_bounces = 10 # Valeur maximale de rebond du laser sur les mirroirs.
@onready var ray = $Ray # Variable du rayon pour accès facile.
@onready var line = $body/Line2D # Variable de la ligne pour accès facile.
var has_timeout = false # Variable qui indique si le temps est écoulé.
var has_won = false # Variable qui indique si le joueur a gagné.

# Méthode appelée à chaque image par seconde.
func _process(_delta):
	line.clear_points() # On supprime tous les points de la scène pouvant exister pour ne pas avoir de bug.
	
	if has_won: # Si la variable has_won est vraie, on envoie un signal pour dire que le casse-tête est complété.
		win.emit()
	
	# Si le joueur relâche la touche du laser, cela veut dire qu'il n'a pas tenu la touche pendant 3 secondes sur la zone gagnante donc on attend que le temps s'écoule pour indiquer que le temps ne s'est pas écoulé.
	if Input.is_action_just_released("interact"):
		await $Timer.timeout # On attends que le temps s'écoule.
		has_timeout = false # On indique que le temps ne s'est pas écoulé, car le joueur n'a pas tenu la touche pendant 3 secondes sur la zone gagnante.
	
	# Si on pèse sur ESPACE ou F, le rayon s'actionne.
	if Input.is_action_pressed("interact"):
		
		line.add_point(Vector2.ZERO) #Le premier point est créé au début de la ligne, donc au début du laser.
		
		# Je défini la position initiale du rayon en le plaçant à la position initiale de la ligne.
		ray.global_position = line.global_position
		# La direction du rayon s'oriente en fonction de la position de la souris. La longueur du rayon souhaitée étant 2000.
		ray.target_position = get_local_mouse_position().normalized() * 2000
		# Met à jour les informations du rayon immédiatement, sans attendre la prochaine image par seconde.
		ray.force_raycast_update() 
		

		var prev = null # Ancien objet de collision.
		var bounces = 0  # On initialise le nombre de réflexion à 0.
		
		# C'est la boucle qui s'occupe des réflexions du laser sur les mirroirs.
		while true:
			#  Si le rayon n'a pas de collision, on le fait apparaître quand même, on le fait apparaître seulement dans les bonnes portions d'angle.
			if not ray.is_colliding():
				var pts = ray.global_position + ray.target_position # On place un point étant à l'endroit où le rayon se trouve additioné à l'endroit où il pointe pour avoir la bonne direction de la ligne en fonction de la position de la souris.
				line.add_point(line.to_local(pts))
			
				break # on sort de la boucle, car pas de collisions.
			
			# Ici, on est certain qu'il y a une collision.
			
			var coll = ray.get_collider() # Objet de collision.
			var pt = ray.get_collision_point() # Point de collision.
			
			# On ajoute le point de collision à la ligne.
			line.add_point(line.to_local(pt))
			
			# Si le rayon n'a pas de collision avec les mirroirs, c'est à dire qu'il a une collision avec la zone gagnante ou les autres objets de collision n'étant pas des mirroirs.
			if not coll.is_in_group("Mirrors"):
				# Si le joueur a une collision n'étant pas un mirroir: comme la zone gagnante ou les objets de collisions autour des fibres brisées.
				# Condition générale aux deux conditions: Vérifie si le joueur n'a pas gagné, si le laser a une collision avec la zone gagnante, si le compteur est arrêté.				
				if !has_won and coll.name == "AreaWin" and $Timer.is_stopped():
					# Condition 1: Vérifie si le temps ne s'est pas écoulé.
					if !has_timeout:
						$Timer.start(3) # On démarre le compteur de 3 secondes.
						
					# Condition 2: Si le compteur de 3 secondes s'est écoulé.
					else: if has_timeout:
						has_won = true # La variable indiquant que le joueur a gagné est vrai.
				
				if coll.is_in_group("NoCollision") and prev == null:
					line.clear_points()
				
				break # On sort de la boucle, car pas de collision avec les mirroirs, donc pas de réflexion.
			
			# Ici, on est certain que le rayon a une collision avec un mirroir.
			var normal = ray.get_collision_normal() # Normale perpendiculaire au mirroir.
			
			# Si la normale est zéro, on gère l'exception.
			if normal == Vector2.ZERO:
				break # On sort de la boucle, car on ne veut pas de réflexion.
			
			# Le rayon entre dans le mirroir et s'arrête, donc il faut lui dire qu'il ne peut plus intéragir avec lui directement après que la collision est effectuée./ 
			# S'il y a déjà eu une collision, on fait en sorte que l'ancien mirroir puisse pouvoir intéragir à nouveau avec le rayon.
			if prev != null:
				ray.clear_exceptions() # On enlève les exceptions pour que le rayon puisse indiquer les collisions.
				# Met à jour les informations du rayon immédiatement, sans attendre la prochaine image par seconde.
				ray.force_raycast_update() 
			
			# On définit l'objet de collision actuel comme l'ancien.
			prev = coll
			
			# On désactive la collision du rayon avec le mirroir.
			ray.add_exception(prev) # On ajoute des exceptions pour que le rayon ne puisse pas indiquer les collisions.
			#On met à jour le rayon lorsqu'il fait une réflexion sur un objet de collision.
			ray.global_position = pt # Le nouveau rayon commence à l'endroit où l'ancien fini.
			ray.target_position = ray.target_position.bounce(normal) # La nouvelle direction du rayon est l'ancienne qui rebondit(dans le même angle) par rapport à la normale.
			# Met à jour les informations du rayon immédiatement, sans attendre la prochaine image par seconde.
			ray.force_raycast_update() 
			
			# On augmente le nombre de réflexion de 1.
			bounces += 1
			#Vérification du nombre de réflexion pour ne pas avoir un nombre infini et qu'on manque de mémoire vive.
			if bounces >= max_bounces:
				break #Quitte la boucle de réflexion si la valeur maximale de rebond est atteinte.
		
		# Ici, on est à l'extérieur de la boucle de réflexion.
		# On met à jour l'ancien objet de collision lorsqu'on sort de la boucle pour qu'il puisse intéragir avec le rayon.
		if prev != null:
				ray.clear_exceptions()
				# Met à jour les informations du rayon immédiatement, sans attendre la prochaine image par seconde.
				ray.force_raycast_update() 

# Signal à la fin du sablier.
func _on_timer_timeout():
	has_timeout = true # Le temps s'est bien écoulé.
