class_name Entity
extends CharacterBody3D

@export var max_speed : float = 10
@export var acceleration : float = 70
@export var friction : float = 20
@export var air_friction : float = 10
@export var gravity : float = -40
@export var jump_impulse : float = 20
@export var mouse_sensitivity : float = .1
@export var controller_sensitivity : float = 3
@export var rotation_speed : float = 25

@export var max_health : float = 100
@export var current_health : float = 100
@export var health_regen_rate : float = 1
@export var armor : float = 0

@export var max_mana : float = 100
@export var current_mana : float = 100
@export var mana_regen_rate : float = 1

@export var max_stamina : float = 100
@export var current_stamina : float = 100
@export var stamina_regen_rate : float = 5

@export var ability_1_cooldown : float = 10
@export var ability_2_cooldown : float = 10
@export var ability_3_cooldown : float = 10

@onready var spring_arm = $SpringArm3D
@onready var pivot = $Pivot

var dashing = false

func regen_health(delta):
	if (current_health < max_health):
		if (((delta * health_regen_rate) + current_health) > max_health):
			current_health = max_health
		else:
			current_health += (delta * health_regen_rate)
			
			
func regen_mana(delta):
	if (current_mana < max_mana):
		if (((delta*mana_regen_rate) + current_mana) > max_mana):
			current_mana = max_mana
		else:
			current_mana += (delta * mana_regen_rate)


func regen_stamina(delta):
	if (current_stamina < max_stamina):
		if (((delta * stamina_regen_rate) + current_stamina) > max_stamina):
			current_stamina = max_stamina
		else:
			current_stamina += (delta * stamina_regen_rate)
			
			
func modify_health(amount: float):
	if current_health + amount > max_health: current_health = max_health
	elif current_health + amount < 0: current_health = 0
	else:
		current_health += amount


func modify_mana(amount: float):
	if current_mana + amount > max_mana: current_mana = max_mana
	elif current_mana + amount < 0: current_mana = 0
	else:
		current_mana += amount


func modify_stamina(amount: float):
	if current_stamina + amount > max_stamina: current_stamina = max_stamina
	elif current_stamina + amount < 0: current_stamina = 0
	else:
		current_stamina += amount
		

func load_ability(ability_name: String):
	var scene = load("res://abilities/" + ability_name + "/" + ability_name + ".tscn")
	var scene_node = scene.instantiate()
	add_child(scene_node)
	return scene_node


## This is a function to calculate the input vector given defined inputs
func get_input_vector() -> Vector3:
	# this defines the input vector and we subtract move back from move forward 
	# because the player controller starts facing -z
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
	
## This function will calculate the direction from the input vector
## the direction is helpful for moving the player relative to its current postion
func get_direction(input_vector: Vector3) -> Vector3:
	var direction  = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	
	
## This function takes the input vector and direction to apply movement to the player
func apply_movement(input_vector: Vector3, direction: Vector3, delta: float):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
#		pivot.look_at(global_transform.origin + direction, Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-input_vector.x, -input_vector.z), rotation_speed * delta)
		
		
## This function takes the direction of the player and uses it to apply friction
func apply_friction(direction: Vector3, delta: float):
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
func apply_gravity(delta: float):
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
		
		
	
