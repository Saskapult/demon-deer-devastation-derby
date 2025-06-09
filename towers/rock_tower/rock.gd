extends Area2D


@onready var t_spawn = Time.get_unix_time_from_system()
@export var spawn_to_hit = 1.0
@export var hit_damage = 25.0

var target
@onready var start = get_global_position()


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r


func set_target(new_target):
	target = new_target


func _process(_delta):
	if not target:
		return
	var apex = Vector2((target.x + start.x) / 2.0, max(target.y, start.y) - 100.0)
	var t = (Time.get_unix_time_from_system() - t_spawn) / spawn_to_hit
	global_position = _quadratic_bezier(start, apex, target, t)

	if t > 1.25:
		queue_free()


func hit_some(thing):
	self.monitoring = false
	self.monitorable = false
