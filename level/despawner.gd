extends Area2D

@export var group = ""

signal despawn_something(thing)

func _on_body_entered(area):
	print("Despawn thing?")
	if group == "" or area.is_in_group(group):
		print("Despawn thing")
		area.queue_free()
		despawn_something.emit(area)
