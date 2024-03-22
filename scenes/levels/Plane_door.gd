extends Area2D


func _on_mouse_entered():
	$WhiteRectangle.visible = true
	mouse_inside = true
