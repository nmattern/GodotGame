extends Node3D

@export var dash_speed : float = 40

func execute(s, direction):
	if Input.is_action_just_pressed("shift") and s.current_stamina >= 20:
		s.velocity.x = direction.x * dash_speed
		s.velocity.z = direction.z * dash_speed
		s.current_stamina -= 20
