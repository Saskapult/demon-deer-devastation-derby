extends Node2D


func _ready() -> void:
	Tomatoes.reset()
	
	$GoalDespawner.despawn_something.connect(deer_eated_tomato)

	$CanvasLayer/LossUI.visible = false
	$CanvasLayer/WinnerUI.visible = false
	$CanvasLayer/PauseUI.visible = false

	$CanvasLayer/LossUI/CenterContainer/VBoxContainer/AgainButton.pressed.connect(restart)
	$CanvasLayer/WinnerUI/CenterContainer/VBoxContainer/AgainButton.pressed.connect(restart)
	$CanvasLayer/WinnerUI/CenterContainer/VBoxContainer/HarvestButton.pressed.connect(func (): get_tree().change_scene_to_file("res://menu/menu_scene.tscn"))
	


func restart():
	get_tree().change_scene_to_file("res://scenes/level00.tscn")


func _process(_delta: float) -> void:
	var winner = $DeerSource.waves_are_done && len(get_tree().get_nodes_in_group("deer")) == 0 && Tomatoes.tomatoes > 0
	$CanvasLayer/WinnerUI.visible = winner

	var loss = Tomatoes.tomatoes <= 0
	$CanvasLayer/LossUI.visible = loss

	# Music changes with rockers
	var has_rockers = len(get_tree().get_nodes_in_group("rockers")) != 0
	var has_fate = len(get_tree().get_nodes_in_group("ascended_rockers")) != 0
	if has_rockers:
		if has_fate:
			$MusicPlayer.stream.set_sync_stream_volume(0, -400.0)
			$MusicPlayer.stream.set_sync_stream_volume(1, -400.0)
			$MusicPlayer.stream.set_sync_stream_volume(2, 0.0)
		else:
			$MusicPlayer.stream.set_sync_stream_volume(0, -400.0)
			$MusicPlayer.stream.set_sync_stream_volume(1, 0.0)
			$MusicPlayer.stream.set_sync_stream_volume(2, -400.0)
	else:
		$MusicPlayer.stream.set_sync_stream_volume(0, 0.0)
		$MusicPlayer.stream.set_sync_stream_volume(1, -400.0)
		$MusicPlayer.stream.set_sync_stream_volume(2, -400.0)
	if not $MusicPlayer.playing:
		$MusicPlayer.play()


func deer_eated_tomato(_deer):
	print("Tomato down :(")
	Tomatoes.dec_tomato()
