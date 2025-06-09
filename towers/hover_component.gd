extends Area2D

signal hover_clicked

var hovered = false


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false


func _on_input_event(viewport, event, shape_idx):
	if hovered and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		hover_clicked.emit()
