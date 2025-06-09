extends Node


signal tomato_decrease
signal no_more_tomato

var tomatoes = 16
var money = 32

func _ready() -> void:
	tomato_decrease.connect(dec_tomato)
	Events.deer_fucks_off.connect(func (score): money += score)


func reset():
	# Gotta reset after lose game!
	tomatoes = 16
	money = 32


func dec_tomato():
	tomatoes -= 1
	tomatoes = max(tomatoes, 0)
	if tomatoes <= 0:
		no_more_tomato.emit()


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_M):
		money += 4