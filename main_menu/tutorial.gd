extends Node2D

@onready var button_start = $BaseSurface/st_button

func _ready() -> void:
	button_start.connect("pressed", self.start_game)

func start_game() -> void:
	var new_scene = load("res://main_menu/guide.tscn")
	get_tree().change_scene_to_packed(new_scene)
