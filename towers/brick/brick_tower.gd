extends Node2D

# Tower header
@export var tower_name: String = "Brick Tower"
@export var description: String = "Don't throw bricks at deer! Where did you even get those??"
@export var cost: int = 32
@export var upgrades: Array[PackedScene] = [
	load("res://towers/pride/pride_tower.tscn")
]

var t_last_throw
@export var throw_period = 2.0

@export var Projectile = load("res://towers/brick/brick.tscn")


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
			proj.global_position = global_position
			get_tree().current_scene.add_child(proj)
			proj.send_at($TargetingComponent.target)


func _on_hover_component_hover_clicked() -> void:
	Events.tower_selected.emit(self)
