extends Area2D

signal electrical_box_clicked

var mouse_inside:bool = false

func _on_mouse_entered():
	$WhiteRectangle.visible = true


func _on_mouse_exited():
	$WhiteRectangle.visible = false

func _process(_delta):
	if mouse_inside && Input.is_action_just_pressed("clicked"):
		electrical_box_clicked.emit()
