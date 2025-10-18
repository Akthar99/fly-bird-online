extends Node2D

@export var settings_res: Settings
@export var background: Sprite2D # position ( 310, 470 )
@export var background_scroller: Array[Sprite2D] 
var background_speed: int = 150
var bg_volume_lowering_amount: float = 5.0
var available_music_tracks: Array 
@onready var _bg: Node2D = $bg
@onready var main_menu: Control = $"main menu"
@onready var default_bg_music: AudioStreamPlayer = $default_bg_music




func _ready() -> void:
	background_scroller.append(background) # push the first background sprite to background_scroller
	default_bg_music.volume_db = settings_res.bg_default_volume_amount

# TODOS : [
#		create the cycling iteration 🆗
#		make background looping efect 🆗
#		add a shader to the bird when touched the ground
#		add a shader to the background 
#			]

func _process(delta: float) -> void:
	draw_background(delta)
	
	#
func draw_background(delta) -> void:
#	check wheather the array ( background_scoller ) has more than 3 items
	if check_max(background_scroller, 3):
#		proceed to draw Items ( Sprite2D )
		for bg in background_scroller:
			bg.visible = true
			bg.position.x -= background_speed * delta # move the background
			cycle_background(background_scroller)
	else:
		# check weather array has more than 3 items 
		if len(background_scroller) > 3:
			push_error("background_scroller array length exceeded --CODE BREAK--")
		# background_scroller has less than 3 sprites 
		fit_background_scroller() # fit the all 3 backgrounds togather
		

func fit_background_scroller():
	# in this iteration I'm adding new sprite with fixed position until it get to 3 items in the array
	for i in range(3):
		if len(background_scroller) >= 3:
			break
		var new_background_sprite: Sprite2D = background.duplicate()
		# since position is calculated in center we have to add additional 310
		new_background_sprite.position = Vector2((background.position.x * 2) * (i + 1) + 310, background.position.y)
		background_scroller.append(new_background_sprite)
		_bg.add_child(new_background_sprite) # adding the newly created sprite to the tree

func cycle_background(arr: Array[Sprite2D]):
	if check_position(arr): 
		var temp: Sprite2D = arr.pop_front()
		arr.push_back(temp)
	re_arrange_position(arr)
	
func re_arrange_position(arr: Array[Sprite2D]):
	# check the last sprite for position, If it is past the screen
	if check_position(arr, false):
		arr.back().position = Vector2((arr.front().position.x) + 620 * 2, background.position.y)
	else: 
		return

func check_position(arr: Array[Sprite2D], front: bool = true):
	if front:
		return arr[0].position.x < -310 # 310 is the fixed x position since the sprite's origin is the center 310 + 310 = 620 :) 
	else: 
		return arr.back().position.x < -310

func check_max(arr: Array, amount: int) -> bool:
	return len(arr) == amount
	

# emmiting from control
func _on_control_screenshot_error(error: Error) -> void:
	print(error)

# hide the main menu after game started
func _on_control_start() -> void:
	main_menu.visible = false
	# lower the default bg music down

# show the main menu after resuming the game 
func _on_main_menu_stop() -> void:
	main_menu.visible = true
	# turn the default bg music up

# ground area logic
func _on_area_2d_body_entered(body: Node2D) -> void:
	var y_spd: Vector2 = body.get_velocity()
	y_spd.y = -400
	if body.name == "Bird":
		body.set_global_velocity(y_spd) # add new velocity to the bird
		body.set_global_triger_effect() # add bird hurt shader 
	


func _on_main_menu_volume_changed() -> void:
	default_bg_music.volume_db = settings_res.bg_default_volume_amount
