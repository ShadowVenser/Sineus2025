extends CanvasLayer

signal clicked(label: String)

@onready var flow: FlowContainer = $Control/MarginContainer/ScrollContainer/ButtonsFlow

var items: Array[String] = ["One", "Two", "Exit"]

func _ready() -> void:
	populate(items)

func populate(labels: Array[String]) -> void:
	_clear_flow()
	for i in labels.size():
		var b := Button.new()
		b.text = labels[i]
		b.custom_minimum_size = Vector2(120, 36)
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.pressed.connect(_on_button_pressed.bind(labels[i], i))
		flow.add_child(b)

func add_button(label: String) -> void:
	var b := Button.new()
	b.text = label
	b.custom_minimum_size = Vector2(120, 36)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	b.pressed.connect(_on_button_pressed.bind(label, flow.get_child_count()))
	flow.add_child(b)

func _clear_flow() -> void:
	for c in flow.get_children():
		c.queue_free()

func _on_button_pressed(label: String, idx: int) -> void:
	emit_signal("clicked", label)
