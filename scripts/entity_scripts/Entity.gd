class_name Entity
extends CharacterBody3D

@export var max_speed = 10
@export var acceleration = 70
@export var friction = 10
@export var air_friction = 10
@export var gravity = -40
@export var jump_impulse = 20
@export var mouse_sensitivity = .1
@export var controller_sensitivity = 3
@export var rotation_speed = 25


@onready var spring_arm = $SpringArm3D
@onready var pivot = $Pivot

## This is a function to calculate the input vector given defined inputs
func get_input_vector():
	# this defines the input vector and we subtract move back from move forward 
	# because the player controller starts facing -z
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
	
	## This function will calculate the direction from the input vector
## the direction is helpful for moving the player relative to its current postion
func get_direction(input_vector):
	var direction  = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	
	
	## This function takes the input vector and direction to apply movement to the player
func apply_movement(input_vector, direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
#		pivot.look_at(global_transform.origin + direction, Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-input_vector.x, -input_vector.z), rotation_speed * delta)
		
		
		## This function takes the direction of the player and uses it to apply friction
func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(direction * max_speed, air_friction * delta).x
			velocity.z = velocity.move_toward(direction * max_speed, air_friction * delta).z
			
			
			## This function applies the jump_impulse to apply a jumping feature
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2
		
		
		## This funnction applies gravity to the y position
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jump_impulse)
	
	
## This function add controller support for rotation of the player
func apply_controller_rotation():
	var axis_vector = Vector3.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if InputEventJoypadMotion:
		rotate_y(deg_to_rad(-axis_vector.x) * controller_sensitivity)
		spring_arm.rotate_x(deg_to_rad(-axis_vector.y) * controller_sensitivity)
		
		
	
