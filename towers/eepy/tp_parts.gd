extends CPUParticles2D

func _ready() -> void:
	emitting = true
	var tween = get_tree().create_tween()
	tween.tween_interval(lifetime)
	tween.tween_callback(queue_free)
