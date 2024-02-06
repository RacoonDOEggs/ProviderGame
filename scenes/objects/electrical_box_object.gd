extends Area2D

signal electrical_box_clicked

var mouse_inside:bool = false

func _on_mouse_entered():
	$WhiteRectangle.visible = true
	mouse_inside = true


func _on_mouse_exited():
	$WhiteRectangle.visible = false
	mouse_inside = false

func _process(_delta):
	if Input.is_action_just_pressed("clicked") && mouse_inside:
		electrical_box_clicked.emit()
