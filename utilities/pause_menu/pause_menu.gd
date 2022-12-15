extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button = find_child("ResumeButton")
@onready var level_select_button: Button = find_child("LevelSelectButton")

## Preload the level select screen
var level_select_scene = preload("res://gui/level_select_screen.gd").instantiate()

func _ready() -> void:
	resume_button.pressed.connect(unpause)
	level_select_button.pressed.connect(level_select_menu())

## Plays animation before giving mouse control back to player
func unpause():
	animator.play("Unpause")
	get_tree().paused = false
	Input.MOUSE_MODE = Input.MOUSE_MODE_CAPTURED

## Plays animation and locks players mouse while a menu is shown
func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.MOUSE_MODE = Input.MOUSE_MODE_VISIBLE

## Brings player back to level select screen
func level_select_menu():
	get_tree().change_scene_to_packed(level_select_scene)
