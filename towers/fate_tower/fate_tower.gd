extends Node2D

# Tower header
@export var tower_name: String = "Fate Tower"
@export var description: String = "The demon code prevents the deer from turning down a rock-off. If the deer had minds to blow, they would be blown!"
@export var cost: int = 64
@export var upgrades: Array[PackedScene] = [
	# load("res://towers/rocking_tower/rocking_tower.tscn"),
]

var t_last_projectile
@export var projectile_period = 0.5
@export var projectile_period_inter = projectile_period / 4.0
@export var Projectile : PackedScene
var projectiles_accum = []


func _ready():
	$AnimatedSprite2D.play()
	$HoverComponent.hover_clicked.connect(_on_hover_component_hover_clicked)


func generate_tune():
	var proj = Projectile.instantiate()
	
	if len(projectiles_accum) == 0:
		proj.global_position = $TunesPoint00.global_position
	elif len(projectiles_accum) == 1:
		proj.global_position = $TunesPoint01.global_position
	elif len(projectiles_accum) == 2:
		proj.global_position = $TunesPoint02.global_position
	else:
		print("That's not meant to happen")
	get_tree().current_scene.add_child(proj)
	projectiles_accum.append(proj)
	$StrumPlayer.play()


func _process(_delta):
	if not $TargetingComponent.target_is_valid():
		$TargetingComponent.find_target()
	
	if $TargetingComponent.target_is_valid():
		var now = Time.get_unix_time_from_system()
		if (not t_last_projectile) or (now - t_last_projectile > projectile_period):
			t_last_projectile = now

			var target = $TargetingComponent.target
			for proj in projectiles_accum:
				proj.send_at(target)
			projectiles_accum = []

			var tween = get_tree().create_tween()
			tween.tween_interval(projectile_period_inter)
			tween.tween_callback(generate_tune)
			tween.tween_interval(projectile_period_inter)
			tween.tween_callback(generate_tune)
			tween.tween_interval(projectile_period_inter)
			tween.tween_callback(generate_tune)


func _on_hover_component_hover_clicked() -> void:
	Events.tower_selected.emit(self)
