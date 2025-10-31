extends Control

@onready var button_new_game = $VBoxContainer/ng_button
@onready var button_exit = $VBoxContainer/exit_button
@onready var btn = $TextureButton


func _ready() -> void:
	button_new_game.anchor_left = 0
	button_new_game.anchor_top = 0
	button_new_game.anchor_right = 1
	button_new_game.anchor_bottom = 1
	button_new_game.offset_left = 0
	button_new_game.offset_top = 0
	button_new_game.offset_right = 0
	button_new_game.offset_bottom = 0
	button_new_game.stretch_mode = TextureButton.STRETCH_SCALE  # заставляем текстуру масштабироваться
	
	button_new_game.connect("pressed", self.start_game)
	
	button_exit.anchor_left = 0
	button_exit.anchor_top = 0
	button_exit.anchor_right = 1
	button_exit.anchor_bottom = 1
	button_exit.offset_left = 0
	button_exit.offset_top = 0
	button_exit.offset_right = 0
	button_exit.offset_bottom = 0
	button_exit.stretch_mode = TextureButton.STRETCH_SCALE  
	
	button_exit.connect("pressed", self.exit_game)

func start_game() -> void:
	var new_scene = load("res://new_level/new_level.tscn")
	get_tree().change_scene_to_packed(new_scene)

func exit_game() -> void:
	get_tree().quit()
