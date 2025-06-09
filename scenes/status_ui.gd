extends Control

func _ready() -> void:
	Events.wave_update.connect(_on_wave_update)


func _process(_delta):
	$VBoxContainer/TomatoCountLabel.text = "Tomatoes: %s" % Tomatoes.tomatoes
	$VBoxContainer/MoneyLabel.text = "Moneys: %s" % Tomatoes.money


func _on_wave_update(wave_i, waves_total, progress, total) -> void:
	$VBoxContainer/WaveProgressLabel.text = "Wave %s - %s/%s" % [wave_i, progress, total]
