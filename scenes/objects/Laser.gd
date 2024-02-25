#Source pour l'implémentation du laser et des mirroirs : https://www.youtube.com/watch?v=Mgk5eAvzo8k&t=629s

extends StaticBody2D

var max_bounces = 10 
@onready var ray = $Ray
@onready var line = $body/Line2D

func _process(_delta):
	
	# Je supprime tous les points déjà existants dans la scène.
	line.clear_points()
	
	# Si on pèse sur ESPACE ou BOUTON_SOURIS_GAUCHE le rayon s'actionne
	if Input.is_action_pressed("interact"):
		
		#Le premier point est créé sur la ligne.
		line.add_point(Vector2.ZERO)
		
		# Je défini le début du rayon initial en le plaçant au début de la ligne.
		ray.global_position = line.global_position
		# La direction du rayon s'oriente en fonction de la position de la souris.
		ray.target_position = (get_global_mouse_position() - line.global_position).normalized()*10000
		# Applique les changements
		ray.force_raycast_update()
		
		#L'ancien objet avec qui le rayon a eu une collision.
		var prev = null
		# On initialise le nombre de réflexion à 0.
		var bounces = 0
		
		while true:
			#  Si le rayon n'a pas de collision, on ne veut pas que le laisser disparaîsse, donc on ajoute un point à la ligne pour qu'il apparaîsse.
			# Puis on quitte la boucle.
			if not ray.is_colliding():
				var pt = ray.global_position + ray.target_position
				line.add_point(line.to_local(pt))
				break
			
			# On prend en note avec quel objet le rayon a une collision et en quel point.
			var coll = ray.get_collider()
			var pt = ray.get_collision_point()
			
			#On ajoute ce point à la ligne.
			line.add_point(line.to_local(pt))
			
			# Si le rayon n'a pas de collision avec les mirroirs on sort de la boucle.
			if not coll.is_in_group("Mirrors"):
				break
			
			# On prend en note le vecteur perpendiculaire à la surface avec lequel le rayon a une collision.
			var normal = ray.get_collision_normal()
			
			# On vérifie si il n'y aurait pas de normal (exception).
			# On quitte la boucle si c'est vrai.
			if normal == Vector2.ZERO:
				break
			
			# S'il y a eu une collision, on met à jour l'ancien objet de collision.
			if prev != null:
				prev.collision_mask = 3
				prev.collision_layer = 3
			# On met à jour l'ancien objet de collision pour pouvoir faire une nouvelle collision
			prev = coll
			# On fait en sorte que l'ancien objet de collision ne peut plus intéragir avec le rayon.
			prev.collision_mask = 0
			prev.collision_layer = 0
			
			#On met à jour le rayon lorsqu'il fait une réflexion sur un objet de collision.
			ray.global_position = pt
			ray.target_position = ray.target_position.bounce(normal)
			ray.force_raycast_update()
			
			# On augmente le nombre de réflexion de 1.
			bounces += 1
			#Vérification du nombre de réflexion pour ne pas avoir un nombre infini et qu'on manque de mémoire vive.
			if bounces >= max_bounces:
				break
		
		# On met à jour l'ancien objet de collision lorsqu'on sort de la boucle pour qu'il puisse intéragir avec le rayon.
		if prev != null:
				prev.collision_mask = 3
				prev.collision_layer = 3
