extends Node2D


func _ready() -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/StartButton.pressed.connect(start_level)
	# get_tree().quit()


func start_level():
	get_tree().change_scene_to_file("res://scenes/level00.tscn")


