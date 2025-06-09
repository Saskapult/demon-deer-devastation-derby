extends CharacterBody2D

@export var speed = 50.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D

@export var target: Vector2
var spooked = false


func _ready():
	$AnimatedSprite2D.play()
	await get_tree().physics_frame
	nav.velocity_computed.connect(_velocity_computed)
	if target:
		nav.target_position = target

	$HealthComponent.health_depleted.connect(fuck_off)


func _process(delta):
	if (not target) and (not spooked):
		nav.target_position = get_viewport().get_mouse_position()
	move_to_target()


func move_to_target():
	if nav.is_navigation_finished():
		if spooked:
			queue_free()
		return

	var current_agent_position = global_position
	var next_path_position = nav.get_next_path_position()

	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)

	move_and_slide()


func _velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity


func fuck_off():
	print("Fucking off")
	remove_from_group("deer")
	spooked = true
	speed = speed * 4.0

	# Choose a random point off screen, fuck off to there
	var angle = randf_range(0, TAU)
	var distance = randf_range(500.0, 1500.0)
	var destination = global_position + Vector2(sin(angle), cos(angle)) * distance

	nav.target_position = destination
	nav.set_navigation_layer_value(1, false)
	nav.set_navigation_layer_value(2, true)

	var tween = get_tree().create_tween()
	tween.tween_interval(8.0)
	tween.tween_callback(queue_free)

	Events.deer_fucks_off.emit(4)
