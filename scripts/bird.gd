extends CharacterBody2D

@onready var bird_sprite: Sprite2D = $Sprite2D
var shader_mat: ShaderMaterial

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var start: bool = false

func _ready() -> void:
	shader_mat = bird_sprite.material
	shader_mat.set_shader_parameter("triger_effect", false)
	
#	TODO [
#		make shader work when bird collide
#		]

func _physics_process(delta: float) -> void:
	
	if start:
		# Add the gravity.
		velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		
		if velocity.y > 0:
			if bird_sprite.rotation <= .30:
				bird_sprite.rotate(.05)
		if velocity.y < 0:
			if bird_sprite.rotation >= -.30:
				bird_sprite.rotate(-.05)
			
				
		move_and_slide()
		check_wall()


func check_wall():
	if position.y > get_window().size.y:
		print("game end")

func set_global_velocity(arg: Vector2) -> void:
	velocity = arg
	
func set_global_triger_effect() -> void:
	# activate the shader 
	shader_mat.set_shader_parameter("triger_effect", true)
	
	# deactivate after two second 
	await get_tree().create_timer(.5).timeout
	shader_mat.set_shader_parameter("triger_effect", false)
	

func _on_control_start() -> void:
	start = true


func _on_control_stop() -> void:
	start = false
