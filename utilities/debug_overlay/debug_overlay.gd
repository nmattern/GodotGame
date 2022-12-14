extends CanvasLayer

## Utility to display an overlay containing various specified values.
##
## To add a value to the overlay call the [method add_value]

## debug_values is the array that will store nested arrays of the values being added 
## to the overlay
var debug_values = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var label_text = ""
	
	var fps = Engine.get_frames_per_second()
	label_text += str("FPS: ", fps, "\n")
	
	var memory_used = OS.get_static_memory_usage()
	label_text += str("Static Memory: ", String.humanize_size(memory_used), "\n")
	
	for value in debug_values:
		var current_value = null
		if value[1] and weakref(value[1]).get_ref():
			if value[3]:
				current_value = value[1].call(value[2])
			else:
				current_value = value[1].get(value[2])
		label_text += str(value[0], ": ", current_value, "\n")
	
	$Label.text = label_text

## Method to handle appending new text to the debug overlay.[br]
## The parameters are as follows[br]
## [b]value_name[/b]: string representing the name shown in the overlay[br]
## [b]object[/b]: the object (node) that is the parent of the field being referenced[br]
## [b]value_ref[/b]: string of the field being referenced from the object[br]
## [b]is_method[/b]: boolean value to determine if the value being passed is a method[br]
func add_value(value_name, object, value_ref, is_method):
	debug_values.append([value_name, object, value_ref, is_method])
