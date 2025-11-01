extends Node2D
class_name Player

signal deal_damage(_damage: int)
signal player_is_dead()

@onready var name_label = $Control/label
@onready var health_label = $Control/health_label
@onready var animations = $animations
@onready var melee_animation = $melee
@onready var death_animation = $death_animation
@onready var damage_label = $Control/damage_lable
@onready var damage_number_animation = $Control/damage_lable/AnimationPlayer
@onready var clash_sound = $AudioStreamPlayer2D

#const sound_cash = [preload("res://sfx/sword-clash-241729.mp3"), preload("res://sfx/sword-clashhit-393837.mp3"), 
#preload("res://sfx/sword-slice-2-393845.mp3"), preload("res://sfx/sword-slice-393847.mp3")]

static var all_spells: Dictionary = {
	"fireball": FireballSpell, 
	"heal": HealSpell,
	"freeze": FreezeSpell, 
	"scorched_earth": ScorchedEarthSpell, 
	"nova": NovaSpell,
	"self_burn": SelfBurnEffect,
	"self_freeze": SelfFreezeEffect,
	"time_skip": TimeSkipDementia, 
	"time_hold": TimeHoldDementia,
}

static var all_dementia_spells: Array[String] = [
	"self_burn", "self_freeze", "time_skip", "time_hold"
]

var available_spells: Array[String] = [
	"fireball",
	"heal",
]

var enemy: Enemy
var rythm: WorldRythm

var max_health: int = 35
var health: int = max_health
var base_melee_damage: int = 5
var base_block: int = 2
var block_flag: bool = false
var turn_counter: int = 0
var damage_type: String = ""

var current_dementia: Array[String] = [
	"", "", ""
]

func heal(heal: int) -> void:
	health = min(health + heal, max_health)
	health_label.text = "%d / %d" % [health, max_health]
	damage_label.add_theme_color_override("font_color", Color(0, 1, 0))
	damage_number_animation.play("moving_number")
	damage_label.text = "+" + str(heal)

func _ready() -> void:
	health_label.text = "%d / %d" % [health, max_health]
	animations.play("idle")
	animations.connect("animation_finished", stop_animation)
	melee_animation.connect("animation_finished", stop_melee)
	melee_animation.hide()

func attack():
	print("Mage is attacking!")
	melee_animation.show()
	melee_animation.play("swing")
	emit_signal("deal_damage", base_melee_damage)
	
func block():
	print("Mage is blocking!")
	animations.play("block")
	block_flag = true
	
func cast_spell(spell_name:String):
	var obj = all_spells[spell_name].new()
	obj.cast(self, enemy, rythm)
	animations.show()	
	animations.play("cast_spell")

func take_damage(damage: int):
	if block_flag:
		block_flag = false
		damage -= base_block
	health -= damage
	health_label.text = "%d / %d" % [health, max_health]
	damage_label.add_theme_color_override("font_color", Color(1, 0, 0))
	damage_number_animation.play("moving_number")
	damage_label.text = "-" + str(damage)
	print("Mage takes damage ", damage)
	if health <= 0:
		print("Mage is dead")
		emit_signal("player_is_dead")

func get_current_spells() -> Array[String]:
	if available_spells.size() <= 4:
		return available_spells.duplicate()
	var current_spells = available_spells.duplicate()
	while current_spells.size() > 4:
		current_spells.erase(current_spells[randi_range(0, current_spells.size() - 1)])
	return current_spells

func set_dementia_spell()->void:
	var x = randf()
	if (x<0.35):
		print("FUCK!")
		current_dementia[0] = all_dementia_spells[randi_range(0, all_dementia_spells.size() - 1)]
		var spell: DementiaSpell = all_spells[current_dementia[0]].new()
		current_dementia[1] = spell.get_spell_name()
		current_dementia[2] = spell.get_spell_description()
	else:
		current_dementia = ["", "", ""]

func get_dementia_spell()->Array[String]:
	return current_dementia

func add_spell():
	if (available_spells.size() < 5):
		available_spells.append(all_spells.keys()[available_spells.size()])

func change_visibility(flag: bool):
	health_label.visible = flag
	name_label.visible = flag
	
func stop_animation():
	animations.play("idle")
	
func stop_melee():
	melee_animation.hide()
