extends Node

signal screenshot_taken
signal screenshot_error(error: Error)
signal start 
signal stop
signal volume_changed

@onready var box_container: VBoxContainer = $BoxContainer
@onready var settings_i: MarginContainer = $settingsI
@onready var volume_slider: HSlider = $settingsI/VBoxContainer/HSlider

@export var settings_res: Settings


func _ready() -> void:
	volume_slider.value = settings_res.bg_default_volume_amount

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("take_screenshot"):
		take_screenshot()
		
	if event.is_action_pressed("escape"):
		emit_signal("stop") # stop the player 
		if box_container.hidden:
			box_container.show()
			settings_i.hide()
		
func take_screenshot():
	# get current viewport
	var view_port = get_viewport()
	
	# get the texture from the viewport 
	var texture = view_port.get_texture()
	
	# convert the texture into image 
	var image = texture.get_image()
	
	var timestamp = Time.get_datetime_string_from_system().replace(":", "-").replace(" ", "_")
	var filename = "res://screenshots/" + timestamp + ".png"
	
	var error = image.save_png(filename)
	
	if error == OK:
		emit_signal("screenshot_taken")
	else:
		emit_signal("screenshot_error", error)


func _on_button_pressed() -> void:
	emit_signal("start")


func _on_settings_button_pressed() -> void:
	box_container.hide()
	settings_i.show()
	


func _on_h_slider_value_changed(value: float) -> void:
	settings_res.bg_default_volume_amount = value
	emit_signal("volume_changed")
	print("h_slider value -> ", value, "settings_res value -> ", settings_res.bg_default_volume_amount)


func _on_level_1_game_over(socre: int) -> void:
	emit_signal("stop")
	print("You scored -> ", socre)
