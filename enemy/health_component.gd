extends Area2D


@export var health = 100.0

signal health_depleted
signal health_changed(old_value, new_value)


func _on_area_entered(area):
	if area.is_in_group("projectiles"):
		# print("Hit")
		area.hit_some(self)
		var old_health = health
		health -= area.hit_damage
		health_changed.emit(old_health, health)
		if health <= 0.0 and old_health > 0.0:
			print("Health depleted")
			health_depleted.emit()
