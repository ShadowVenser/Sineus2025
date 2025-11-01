extends Control

var page_nmb = 0
@onready var pages = [
	[
		$BaseSurface/TextureRect2/Guide1,
		$BaseSurface/TextureRect2/p1
	], [
		$BaseSurface/TextureRect2/Guide2,
		$BaseSurface/TextureRect2/p2
	], [
		$BaseSurface/TextureRect2/Guide3,
		$BaseSurface/TextureRect2/p3
	], [
		$BaseSurface/TextureRect2/Guide4,
		$BaseSurface/TextureRect2/p4,
		$BaseSurface/st_button,
	]
]
@onready var left_btn = $BaseSurface/left_btn
@onready var right_btn = $BaseSurface/right_btn
@onready var start_button = $BaseSurface/st_button

func draw_page() -> void:
	left_btn.show()
	right_btn.show()
	if page_nmb == 0:
		left_btn.hide()
	if page_nmb == pages.size() - 1:
		right_btn.hide()
	for current_namber in range(pages.size()):
		for element in pages[current_namber]:
			if current_namber == page_nmb:
				element.show()
			else:
				print(element)
				element.hide()
		

func _ready() -> void:
	draw_page()
	left_btn.connect("pressed", self.move_left)
	right_btn.connect("pressed", self.move_right)
	start_button.connect("pressed", self.start)
	return
	
func move_left():
	page_nmb += pages.size() - 1
	page_nmb %= pages.size()
	draw_page()
	
func move_right():
	page_nmb += 1
	page_nmb %= pages.size()
	draw_page()
	
func start() -> void:
	var new_scene = load("res://new_level/new_level.tscn")
	get_tree().change_scene_to_packed(new_scene)
	
