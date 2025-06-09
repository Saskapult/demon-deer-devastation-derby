extends Node2D


@export var build_ui = load("res://scenes/tower_build_menu.tscn")

var build_menu


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if build_menu:
				build_menu.queue_free()
				build_menu = null

			build_menu = build_ui.instantiate()
			build_menu.global_position = get_viewport().get_mouse_position()
			get_tree().current_scene.add_child(build_menu)


func _process(_delta: float) -> void:
	if build_menu:
		if (build_menu.global_position - get_viewport().get_mouse_position()).length() > 100.0:
			build_menu.queue_free()
			build_menu = null
