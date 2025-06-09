extends CharacterBody2D

var speed := 50.0 # can be anything

@onready var nav: NavigationAgent2D = $NavigationAgent2D # change if needed
# @onready var target: CharacterBody2D = %Player # change if needed


func _ready() -> void:
	actor_setup.call_deferred()
	nav.velocity_computed.connect(_velocity_computed)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target()

func set_movement_target():#(movement_target: Vector2):
	nav.target_position = get_viewport().get_mouse_position()

func _physics_process(delta: float) -> void:
	_move_towards_player()
	

func _move_towards_player():
	# Update the player position
	set_movement_target()

	# If we're at the target, stop
	if nav.is_navigation_finished():
		return

	# Get pathfinding information
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav.get_next_path_position()

	# Calculate the new velocity
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed

	# Set correct velocity
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)

	# Do the movement
	move_and_slide()

func _velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
