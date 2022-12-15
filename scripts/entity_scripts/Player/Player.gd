extends Entity

#@export var max_speed = 10
#@export var acceleration = 70
#@export var friction = 10
#@export var air_friction = 10
#@export var gravity = -40
#@export var jump_impulse = 20
#@export var mouse_sensitivity = .1
#@export var controller_sensitivity = 3
#@export var rotation_speed = 25

#@onready var spring_arm = $SpringArm3D
#@onready var pivot = $Pivot

var player_velocity = Vector3.ZERO
var snap_vector = Vector3.ZERO


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


## This function handles the mouse click events and spring arm movement
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("toggle_mouse_captured"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		spring_arm.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-75), deg_to_rad(75))


## This is the physics process function that runs each frame
## All changes to player position / movement need to be run here
func _physics_process(delta):
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(input_vector, direction, delta)
	apply_friction(direction, delta)
	apply_gravity(delta)
	move_and_slide()
	jump()
	apply_controller_rotation()
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	
	

	
	

	
	










	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	