#Source pour l'implémentation du laser et des mirroirs : https://www.youtube.com/watch?v=Mgk5eAvzo8k&t=629s
extends StaticBody2D

var max_bounces = 10 
@onready var ray = $Ray
@onready var line = $body/Line2D
var check = false
var can_win = false

func _process(_delta):
	line.clear_points()
	
	# Si on pèse sur ESPACE ou F le rayon s'actionne.
	if Input.is_action_pressed("interact"):
		
		#Le premier point est créé au début de la ligne, donc au début du laser.
		line.add_point(Vector2.ZERO)
		
		# Je défini la position initiale du rayon en le plaçant à la position initiale de la ligne.
		ray.global_position = line.global_position
		# La direction du rayon s'oriente en fonction de la position de la souris.
		ray.target_position = get_local_mouse_position().normalized() * 2000
		
		# Met à jour les informations à propos des collisions.
		ray.force_raycast_update()
		
		# Vérifie si l'angle du rayon est celui qui permet le rayon de faire une réflexion jusqu'à la zone gagnante(La fibre brisée de droite).
		# On envoie un signal à la scène du casse-tête pour ensuite partir un compteur.
		var angles: float = rad_to_deg(ray.target_position.angle())

		# Initialise l'ancien objet avec qui le rayon a eu une collision a nulle.
		var prev = null
		# On initialise le nombre de réflexion à 0.
		var bounces = 0
		
		while true:


			# Gagne si le temps est écoulé et que l'angle est bon.
			if angles <  57 and angles > 54.5 and can_win:
				print("a")
				break
			# Check si l'angle est bon pour partir le temps.
			else: if angles < 57 and angles > 54.5 :
				$Timer.start(1)  
			# Si l'angle n'est pas bon, n'a pas la condition de gagner.
			else:
				can_win = false

			#  Si le rayon n'a pas de collision, on ne veut pas le laisser disparaître, donc on ajoute un point à la ligne pour qu'il apparaîsse.
			if not ray.is_colliding():
				# L'angle de rotation du laser
				var angle = rad_to_deg(ray.target_position.angle())
				
				# Si l'angle se trouve dans la portion acceptée du casse-tête, on le laisse.
				if angle < 60 and angle > 5:
					var pt = ray.global_position + ray.target_position
					line.add_point(line.to_local(pt))
					
					# Si l'angle se trouve plus bas que la portion acceptée, on l'arrête.
				else: if angle > 60:
					var pt = Vector2(5313.137, 8790.025)
					line.add_point(line.to_local(pt))
					
					# Si l'angle se trouve plus haut que la portion acceptée, on l'arrête.					
				else: if angle < 5:
					var pt = Vector2(10199.31, 1063.07)
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


func _on_timer_timeout():
	can_win = true
	print("timeout")
