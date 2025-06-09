extends Control


@export var towers = [
	load("res://towers/rock_tower/rock_tower.tscn"),
]

@onready var tower_list = $VBoxContainer/VBoxContainer


func build_tower(tower):
	var t = tower.instantiate()
	if Tomatoes.money >= t.cost:
		Tomatoes.money -= t.cost
		t.global_position = global_position
		get_tree().current_scene.add_child(t)
		queue_free()


func _ready() -> void:
	for tower in towers:
		var u = tower.instantiate() # Needed to access variables
		var label = Button.new()
		label.text = "%s - %s" % [u.cost, u.tower_name]
		tower_list.add_child(label)
		label.pressed.connect(func (): build_tower(tower))
