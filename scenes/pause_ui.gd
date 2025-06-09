extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/QuitButton.pressed.connect(func ():
		get_tree().paused = false 
		get_tree().change_scene_to_file("res://menu/menu_scene.tscn")
	)
	$CenterContainer/VBoxContainer/ResumeButton.pressed.connect(func (): get_tree().paused = false)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if visible:
			get_tree().paused = false
		else:
			get_tree().paused = true
	visible = get_tree().paused
