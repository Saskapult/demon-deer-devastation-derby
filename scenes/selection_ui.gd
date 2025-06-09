extends Control


var tower

func _ready() -> void:
	Events.tower_selected.connect(focus_tower)
	$VBoxContainer/ItemList.item_selected.connect(upgrade_tower)


func _process(_delta: float) -> void:
	visible = not not tower



func focus_tower(new_tower):
	tower = new_tower
	print("select new")
	$VBoxContainer/TowerNameLabel.text = tower.tower_name
	$VBoxContainer/TowerDescLabel.text = tower.description
	$VBoxContainer/ItemList.clear()
	for upgrade in tower.upgrades:
		var u = upgrade.instantiate() # Needed to access variables
		$VBoxContainer/ItemList.add_item("%s - %s" % [u.cost, u.tower_name])


func upgrade_tower(index: int) -> void:
	var new_tower = tower.upgrades[index].instantiate()
	if Tomatoes.money >= new_tower.cost:
		Tomatoes.money -= new_tower.cost
		new_tower.global_position = tower.global_position
		get_tree().current_scene.add_child(new_tower)
		tower.queue_free()
		focus_tower(new_tower)
