extends Node2D

# Tower header
@export var tower_name: String = "Rock Tower"
@export var description: String = "Scares off deer using rocks. Do not throw rocks at deer irl! Use something like a pinecone instead."
@export var cost: int = 16
@export var upgrades: Array[PackedScene] = [
	load("res://towers/rocking_tower/rocking_tower.tscn"),
	load("res://towers/eepy/eepy.tscn"),
	load("res://towers/brick/brick_tower.tscn"),
]

var t_last_throw
@export var throw_period = 2.0

@export var Projectile : PackedScene


func _ready():
	$AnimatedSprite2D.play()
	$HoverComponent.hover_clicked.connect(_on_hover_component_hover_clicked)
	

func _process(_delta):
	if not $TargetingComponent.target_is_valid():
		$TargetingComponent.find_target()
	
	if $TargetingComponent.target_is_valid():
		var now = Time.get_unix_time_from_system()
		if (not t_last_throw) or (now - t_last_throw > throw_period):
			t_last_throw = now
			$AudioStreamPlayer.play()
			var proj = Projectile.instantiate()
			proj.global_position = $RockSpawnPoint.global_position
			proj.set_target($TargetingComponent.target.global_position + $TargetingComponent.target.velocity * proj.spawn_to_hit)
			get_tree().current_scene.add_child(proj)


func _on_hover_component_hover_clicked() -> void:
	Events.tower_selected.emit(self)
