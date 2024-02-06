extends Area2D

var is_dragging:bool = false
var draggable:bool = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos:Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("clicked") and draggable:
		initialPos = global_position
		offset = get_global_mouse_position() - global_position
		is_dragging = true
	if Input.is_action_pressed("clicked") and draggable:
		global_position = get_global_mouse_position() - offset
	elif Input.is_action_just_released("clicked") and draggable:
		is_dragging = false
		var tween = create_tween()
		if is_inside_dropable:
			tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
		else:
			tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)


func _on_mouse_entered():
	if not is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)


func _on_mouse_exited():
	if  not is_dragging:
		draggable = false
		scale = Vector2(1,1)


func _on_body_entered(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		var body_color = body.default_color
		body.modulate = body_color + Color("070707", 1)
		body_ref = body


func _on_body_exited(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = false
		var body_color = body.default_color
		body.modulate = body_color - Color("070707", 0.3)
