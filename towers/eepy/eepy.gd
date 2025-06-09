extends Node2D

# Tower header
@export var tower_name: String = "Eepy Tower"
@export var description: String = "Life's in the way of this jam so I have like 12 hours of working time less than I'd expected. That's not cnounting sleeping time! Anyway, this thing deams that deer are not eating its tomatoes."
@export var cost: int = 32
@export var upgrades: Array[PackedScene] = []

@export var pew_period = 1.0
@export var dilation = 1.0
var t_last_pew
@export var tp_particles = load("res://towers/eepy/tp_parts.tscn")


func _ready():
	$AnimatedSprite2D.play()
	$HoverComponent.hover_clicked.connect(_on_hover_component_hover_clicked)
	$TargetingComponent.debug_draw = true # Looks cool


func make_particles(pos):
	var i = tp_particles.instantiate()
	i.global_position = pos
	get_tree().current_scene.add_child(i)


func teleport_thing_to(thing, pos) -> void:
	if thing:
		make_particles(thing.global_position)
		make_particles(pos)
		thing.global_position = pos
		$StrumPlayer.play()


func _process(_delta):
	if not $TargetingComponent.target_is_valid():
		$TargetingComponent.find_target()
	
	if $TargetingComponent.target_is_valid():
		var now = Time.get_unix_time_from_system()
		if (not t_last_pew) or (now - t_last_pew > pew_period):
			t_last_pew = now

			var pos_last_pew = $TargetingComponent.target.global_position

			var tween = get_tree().create_tween()
			tween.tween_interval(dilation)
			tween.tween_callback(func (): teleport_thing_to($TargetingComponent.target, pos_last_pew))


func _on_hover_component_hover_clicked() -> void:
	Events.tower_selected.emit(self)
