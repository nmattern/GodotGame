extends Control

const LEVEL_BTN = preload("res://gui/lvl_btn.tscn")
@export_dir var dir_path

@onready var grid = $MarginContainer/VBoxContainer/GridContainer

func _ready() -> void:
	get_levels(dir_path)

func get_levels(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var dir_name = dir.get_next()
		while dir_name != "":
			var level_dir = DirAccess.open(path + "/" + dir_name)
			level_dir.list_dir_begin()
			var file_name = level_dir.get_next()
			create_level_btn(level_dir.get_current_dir() + "/" + file_name, file_name)
			dir_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
		
		
func create_level_btn(lvl_path, lvl_name):
	var btn = LEVEL_BTN.instantiate()
	btn.text = lvl_name.trim_suffix('.tscn').replace("_", " ")
	btn.level_path = lvl_path
	grid.add_child(btn)
