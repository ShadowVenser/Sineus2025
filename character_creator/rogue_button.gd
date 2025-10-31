extends Button

signal button_with_name (button_name: String)

func _ready() -> void:
	button_down.connect(pressed_with_name)

func pressed_with_name() -> void:
	emit_signal("button_with_name", self.name) 
