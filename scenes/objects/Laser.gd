#Source pour l'implémentation du laser et des mirroirs : https://www.youtube.com/watch?v=Mgk5eAvzo8k&t=629s
extends StaticBody2D

var max_bounces = 20 # Valeur maximale de rebond du laser sur les mirroirs.
@onready var ray = $Ray # Variable du rayon.
@onready var line = $body/Line2D # Variable de la ligne.
var has_timeout = false # Variable qui indique si le temps est écoulé.
var has_won = false # Variable qui indique si le joueur a gagné.

func _process(_delta):
	
	line.clear_points() # On supprime tous les points de la scène pouvant exister pour ne pas avoir de bug.
	
	
	# Si le joueur relâche la touche du laser, cela veut dire qu'il ne respecte plus les conditions pour gagner, donc on attend que le temps s'écoule pour indiquer que le temps ne s'est pas écoulé.
	if Input.is_action_just_released("interact"):
		await $Timer.timeout # On attends que le temps s'écoule.
		has_timeout = false # On indique que le temps ne s'est pas écoulé, car le joueur n'a pas respecté les conditions pour gagner en relâchant la touche.
		
	
	# Si on pèse sur ESPACE ou F le rayon s'actionne.
	if Input.is_action_pressed("interact"):
		#Le premier point est créé au début de la ligne, donc au début du laser. Se situe à gauche de la scène.
		line.add_point(Vector2.ZERO)
		
		# Je défini la position initiale du rayon en le plaçant à la position initiale de la ligne.
		ray.global_position = line.global_position
		# La direction du rayon s'oriente en fonction de la position de la souris.
		ray.target_position = get_local_mouse_position().normalized() * 2000
		
		# Met à jour les informations à propos des collisions.
		ray.force_raycast_update()

		var prev = null # Ancien objet de collision.
		var bounces = 0  # On initialise le nombre de réflexion à 0.
		
		# C'est la boucle qui s'occupe des réflexions du laser sur les mirroirs.
		while true:

			#  Si le rayon n'a pas de collision, on ne veut pas le laisser disparaître, donc on ajoute un point à la ligne pour qu'il apparaîsse.
			if not ray.is_colliding():
				
				var angle = rad_to_deg(ray.target_position.angle())# L'angle de rotation du laser
				
				#Ici, je m'occupe de la portion de la scène dont le joueur est en mesure d'orienter le laser, il y a donc des restrictions.
				# Si l'angle se trouve dans la portion acceptée du casse-tête, on le laisse.
				if angle < 60 and angle > 5:
					var pts = ray.global_position + ray.target_position
					line.add_point(line.to_local(pts))
					
					# Si l'angle se trouve plus bas que la portion acceptée, on l'arrête.
				else: if angle > 60:
					var pts = Vector2(5313.137, 8790.025)
					line.add_point(line.to_local(pts))
					
					# Si l'angle se trouve plus haut que la portion acceptée, on l'arrête.					
				else: if angle < 5:
					var pts = Vector2(10199.31, 1063.07)
					line.add_point(line.to_local(pts))
				break
			
			# Ici, on est certain qu'il y a une collision.
			
			var coll = ray.get_collider() # Objet de collision
			var pt = ray.get_collision_point() # Point de collision.

			# On ajoute le point de collision à la ligne.
			line.add_point(line.to_local(pt))
			
			# Si le rayon n'a pas de collision avec les mirroirs, donc avec la zone gagnante ou les autres objets de collision n'étant pas des mirroirs.
			if not coll.is_in_group("Mirrors"):
				
				# Condition générale aux deux conditions: Vérifie si le joueur n'a pas gagné, si le laser est dans la bonne zone gagnante, si le sablier est arrêté.
				if !has_won and coll.name == "AreaWin" and $Timer.is_stopped():
					
					# Condition 1: Vérifie si le temps ne s'est pas écoulé.
					if !has_timeout:
						print("entering area")
						$Timer.start(3) # On démarre le sablier de 3 secondes.
						
					# Condition 2: Si le temps s'est écoulé.
					else: if has_timeout:
						print("win")
						has_won = true
				
				break # On sort de la boucle, car pas de collision avec les mirroirs.
			
			var normal = ray.get_collision_normal() # Normale perpendiculaire au mirroir.
			
			# On vérifie le cas où la normale est de 0(exception).
			# On quitte la boucle si c'est vrai.
			if normal == Vector2.ZERO:
				break
			
			# S'il y a déjà eu une collision, on active la collision de l'ancien objet de collision.
			if prev != null:
				prev.set_collision_layer_value(7,false) # On désactive les couches ne permettant pas la collision.
				prev.set_collision_mask_value(7,false)
				
				prev.set_collision_layer_value(2,true) # Pour active les couches permettant la collision.
				prev.set_collision_mask_value(1,true)
			# On définit l'objet de collision actuel comme l'ancien.
			prev = coll
			# On désactive la collision de l'objet de collision actuel qui est rendu l'ancien.
			prev.set_collision_layer_value(2,false) # On désactive les couches  permettant la collision.
			prev.set_collision_mask_value(1,false)
			
			prev.set_collision_layer_value(7,true) # On active les couches ne permettant pas la collision.
			prev.set_collision_mask_value(7,true)
			
			#On met à jour le rayon lorsqu'il fait une réflexion sur un objet de collision.
			ray.global_position = pt
			ray.target_position = ray.target_position.bounce(normal) # Le rayon effectue le rebond.
			ray.force_raycast_update()
			
			# On augmente le nombre de réflexion de 1.
			bounces += 1
			#Vérification du nombre de réflexion pour ne pas avoir un nombre infini et qu'on manque de mémoire vive.
			if bounces >= max_bounces:
				break # Quitte la boucle de réflexion si la valeur maximale de rebond est atteinte.
		
		# Ici, on est à l'extérieur de la boucle de réflexion.
		# On met à jour l'ancien objet de collision lorsqu'on sort de la boucle pour qu'il puisse intéragir avec le rayon.
		if prev != null:
				prev.set_collision_layer_value(7,false) # On désactive les couches ne permettant pas la collision.
				prev.set_collision_mask_value(7,false)
				
				prev.set_collision_layer_value(2,true) # On active les couches permettant la collision.
				prev.set_collision_mask_value(1,true)

# Signal à la fin du sablier.
func _on_timer_timeout():
	print("timeout")
	has_timeout = true # Le temps s'est bien écoulé.
