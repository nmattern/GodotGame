extends Node3D

@export var dash_speed : float = 40

func execute(s, direction, delta):
	if Input.is_action_just_pressed("shift"):
		s.velocity.x = direction.x * dash_speed
		s.velocity.z = direction.z * dash_speed
