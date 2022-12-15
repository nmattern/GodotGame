extends Area3D

@export var target_scene : String

func _input(event):
	if event.is_action_pressed("enter"):
		if target_scene == "":
			print("Invalid target scene")
			return
		if get_overlapping_bodies().size() > 0:
			next_scene()


func next_scene():
	var error = get_tree().change_scene_to_file(target_scene)
	if error != OK:
		print("Error changing scene")
