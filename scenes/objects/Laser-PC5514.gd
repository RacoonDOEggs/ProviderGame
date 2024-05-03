#AUTEUR :  Xavier Bilodeau
#PROJET : Provider
#NOM DU FICHIER : laser.gd
#DESCRIPTION : S'occupe de la réflexion du laser sur les mirroirs.
extends StaticBody2D

signal optical_win()

var max_bounces = 10 # Valeur maximale du rebond du laser sur les mirroirs.
@onready var ray = $Ray # Variable du rayon pour accès facile.
@onready var line = $body/Line2D # Variable de la ligne pour accès facile.
var has_waited_3sec = false # Variable qui indique si le joueur a attendu 3 secondes.
var has_won = false # Variable indiquant si le casse-tête est complété.

# Méthode appelée à chaque image par seconde.
func _process(_delta):
	line.clear_points() # On supprime tous les points de la scène pouvant exister pour ne pas avoir d'erreurs.
	
	# Si le joueur relâche ESPACE, il n'a pas attendu 3 secondes.
	if Input.is_action_just_released("laser"):
		await $Timer.timeout # On attends que le compteur s'écoule.
		has_waited_3sec = false # On indique que le joueur n'a pas attendu 3 secondes.
	
	# Si on pèse sur ESPACE, le rayon s'actionne.
	if Input.is_action_pressed("laser"):
		#Le premier point est créé au début de la ligne, donc au début du laser.
		line.add_point(Vector2.ZERO)
		# Je définis la position initiale du rayon en le plaçant à la position initiale de la ligne.
		ray.global_position = line.global_position
		# La direction du rayon s'oriente en fonction de la position de la souris.
		ray.target_position = get_local_mouse_position().normalized() * 2000 # 2000 est la longueur du rayon souhaitée
		# Met à jour les informations du rayon immédiatement, sans attendre la prochaine image par seconde.
		ray.force_raycast_update() 
		
		var prev = null # Ancien objet de collision.
		var bounces = 0  # On initialise le nombre de réflexion à 0.
		
		# C'est la boucle qui s'occupe des réflexions du laser sur les mirroirs.
		while true:
			#  Si le rayon n'a pas de collision, on le fait apparaître quand même.
			if not ray.is_colliding():
				# On place un point en fonction de la direction du rayon.
				var pts = ray.global_position + ray.target_position 
				line.add_point(line.to_local(pts)) # Le rayon se trace en une ligne droite.
				
				break # on sort de la boucle, car pas de collision.
			
			# Ici, on est certain qu'il y a une collision.
			
			var coll = ray.get_collider() # Objet de collision.
			var pt = ray.get_collision_point() # Point de collision.
			
			# On ajoute le point de collision à la ligne.
			line.add_point(line.to_local(pt))
			
			# Si le rayon n'a pas de collision avec les mirroirs.
			if not coll.is_in_group("Mirrors"):
				
				# Si le joueur n'a pas gagné ET que la collision est avec la zone gagnante ET que le compteur est arrêté.
				if !has_won and coll.name == "AreaWin" and $Timer.is_stopped():
					
					#Condition 1: Vérifie si le joueur n'a pas attendu 3 secondes.
					if !has_waited_3sec:
						$Timer.start(3) # On démarre le compteur de 3 secondes.
					
					# Condition 2: Si le joueur a attendu 3 secondes.
					else: if has_waited_3sec:
						has_won = true # Variable indiquant que le joueur a gagné.
						Globals.puzzles_done.emit() #Signals indiquant que le casse-tête est complété.
						optical_win.emit()
				
				
				# Si le rayon a une collision avec un autre objet que les mirroirs.
				if coll.is_in_group("no_collision_group") and prev == null:
					line.clear_points() # Supprime tous les points.
				
				
				break # On sort de la boucle, car pas de collision avec les mirroirs, donc pas de réflexion.
			
			
			# Ici, on est certain que le rayon a une collision avec un mirroir.
			var normal = ray.get_collision_normal() # Normale perpendiculaire au mirroir.
			
			# Si la normale est égale à zéro, on quitte la boucle pour éviter des problèmes.
			if normal == Vector2.ZERO:
				break 
			
			# S'il y a déjà eu une collision, on active les signaux de collision du mirroir.
			if prev != null:
				ray.clear_exceptions() # On active les signaux de collision du mirroir.
				# Met à jour les informations du rayon immédiatement, sans attendre la prochaine image par seconde.
				ray.force_raycast_update()
			
			# On définit l'objet de collision actuel comme l'ancien.
			prev = coll
			
			
			ray.add_exception(prev) # On désactive les signaux de collision du mirroir.
			#On met à jour le rayon lorsqu'il fait une réflexion sur un objet de collision.
			ray.global_position = pt # Le nouveau rayon commence à l'endroit où l'ancien fini.
			ray.target_position = ray.target_position.bounce(normal) # On effectue la réflexion.
			# Met à jour les informations du rayon immédiatement, sans attendre la prochaine image par seconde.
			ray.force_raycast_update() 
			
			# On augmente le nombre de réflexion de 1.
			bounces += 1
			#Vérification du nombre de réflexion pour ne pas avoir un nombre infini et qu'on manque de mémoire vive.
			if bounces >= max_bounces:
				break #Quitte la boucle de réflexion si la valeur maximale de rebond est atteinte.
		
		# Ici, on est à l'extérieur de la boucle de réflexion.
		if prev != null:
				ray.clear_exceptions() # On active les signaux de collision du mirroir.
				# Met à jour les informations du rayon immédiatement, sans attendre la prochaine image par seconde.
				ray.force_raycast_update() 

# Signal à la fin du compteur.
func _on_timer_timeout():
	has_waited_3sec = true # Le temps 3 secondes s'est bien écoulé.
