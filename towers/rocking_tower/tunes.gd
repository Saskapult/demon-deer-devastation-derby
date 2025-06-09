extends Area2D

@export var speed = 500.0
@export var hit_damage = 10.0

var velocity = Vector2(0.0, 0.0)


func send_at(target):
	# Leads with target velocity
	var to_target = target.global_position - global_position
	var distance = to_target.length()
	var direction = to_target.normalized()
	var time_to_hit = distance / speed
	var leading_target = to_target + target.velocity * time_to_hit
	velocity = leading_target.normalized() * speed


func _process(delta):
	global_position += velocity * delta


func hit_some(thing):
	self.monitoring = false
	self.monitorable = false
