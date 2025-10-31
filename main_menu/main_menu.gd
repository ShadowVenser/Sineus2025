extends Control

@onready var button_new_game = $VBoxContainer/ng_button
@onready var button_exit = $VBoxContainer/exit_button

func _ready() -> void:
	button_new_game.connect("pressed", self.start_game)
	button_exit.connect("pressed", self.exit_game)

func start_game() -> void:
	var new_scene = load("res://new_level/new_level.tscn")
	get_tree().change_scene_to_packed(new_scene)

func exit_game() -> void:
	get_tree().quit()
