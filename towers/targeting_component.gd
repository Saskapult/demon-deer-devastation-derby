extends Node2D

@export var target_group = "deer"
@export var target_range = 100000.0
@export var debug_draw = false
var target

signal target_changed(old_target, new_target)


func find_target():
	var targets = get_tree().get_nodes_in_group(target_group)
	var closest = target_range
	var new_target = null
	for t in targets:
		var d = global_position.distance_squared_to(t.global_position)
		if d < closest:
			closest = d
			new_target = t
	if new_target != target:
		target_changed.emit(target, new_target)
	target = new_target	


func target_is_valid() -> bool:
	return self.target and self.target.is_in_group(target_group)


func _process(_delta):
	if debug_draw:
		queue_redraw()


func _draw():
	if debug_draw and target:
		var relative_position = target.global_position - global_position
		draw_line(Vector2(0.0, 0.0), relative_position, Color.RED, 1.0)
