extends Node2D

@export var autospawn = false
@export var autospawn_period = 3.0

@export var wave_delay = 8.0
@export var spawn_delay = 0.75

@export var target: Node2D
var last_spawn

@export var Deer: PackedScene

var bastard = load("res://enemy/bastard/bastard.tscn")
var hungry = load("res://enemy/hungry/hungry.tscn")
var waves = [
	[
		[bastard, spawn_delay],
	],
	[
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
	],
	[
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay],
	],
	[
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay*2],
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay*2],
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay*2],
	],
	[
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
	],
	[
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
		[bastard, spawn_delay], [bastard, spawn_delay], [bastard, spawn_delay],
		[hungry, spawn_delay], [hungry, spawn_delay], [hungry, spawn_delay], 
	],
]
var wave_i = 0

# func spawn_deer():
# 	# print("Spawn")
# 	var deer = Deer.instantiate()
# 	deer.global_position = global_position
# 	if target:
# 		deer.target = target.global_position
# 	get_tree().current_scene.add_child(deer)

signal waves_done
var waves_are_done = false


func spawn_next_wave():
	print("Begin wave", wave_i)
	if wave_i >= len(waves):
		waves_done.emit()
		waves_are_done = true
		return
	
	var tween = get_tree().create_tween()
	tween.tween_callback(func (): $AudioStreamPlayer.play())
	var wave = waves[wave_i]
	for i in range(len(wave)):
		var pair = wave[i]
		var type = pair[0]
		var spacing = pair[1]
		var callb = func():
			Events.wave_update.emit(wave_i, len(waves), i+1, len(wave))
			var deer = type.instantiate()
			deer.global_position = global_position
			if target:
				deer.target = target.global_position
			get_tree().current_scene.add_child(deer)
		tween.tween_interval(spacing)
		tween.tween_callback(callb)
	
	wave_i += 1
	tween.tween_interval(wave_delay)
	tween.tween_callback(spawn_next_wave)


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_interval(4.0)
	tween.tween_callback(spawn_next_wave)
