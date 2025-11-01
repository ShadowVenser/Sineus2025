extends Node2D
class_name Player

signal deal_damage(_damage: int)
signal player_is_dead()

@onready var name_label = $Control/label
@onready var health_label = $Control/health_label
@onready var damage_animation = $swing_animation
@onready var damage_position = $damage_pos
@onready var death_animation = $death_animation
@onready var damage_label = $Control/damage_lable
@onready var damage_number_animation = $Control/damage_lable/AnimationPlayer
@onready var clash_sound = $AudioStreamPlayer2D

#const sound_cash = [preload("res://sfx/sword-clash-241729.mp3"), preload("res://sfx/sword-clashhit-393837.mp3"), 
#preload("res://sfx/sword-slice-2-393845.mp3"), preload("res://sfx/sword-slice-393847.mp3")]

static var all_spells: Dictionary = {
	"fireball": FireballSpell, 
	"scorched_earth": ScorchedEarthSpell, 
	"freeze": FreezeSpell, 
	"heal": HealSpell,
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

var health: int = 10
var max_health: int = 35
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

func _ready() -> void:
	health_label.text = "%d / %d" % [health, max_health]
	#damage_animation.animation_finished.connect(stop_animation)
	#damage_animation.hide()
	#death_animation.animation_finished.connect(stop_death_animation)
	#death_animation.hide()
	#self.change_visibility(false)

func attack():
	print("Mage is attacking!")
	emit_signal("deal_damage", base_melee_damage)
	
func block():
	print("Mage is blocking!")
	block_flag = true
	
func cast_spell(spell_name:String):
	var obj = all_spells[spell_name].new()
	obj.cast(self, enemy, rythm)
	
	
func take_damage(damage: int):
	if block_flag:
		block_flag = false
		damage -= base_block
	health -= damage
	health_label.text = "%d / %d" % [health, max_health]
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

#func get_stats(_stats: Dictionary):
	#opponent_stats = _stats
	
#func play_damage_animation(hit: bool = false):
	#clash_sound.stream = sound_cash.pick_random()
	#clash_sound.play()
	#damage_animation.rotation_degrees = [0, 30, 45, 60, 75, 90].pick_random()
	#damage_animation.position = damage_position.position
	#if !hit:
		#damage_animation.position += [Vector2(150, 150), Vector2(-150, -150), Vector2(-150, 150), Vector2(150, -150)].pick_random()
	#damage_animation.show()
	#damage_animation.play()
	#
#func stop_animation():
	#damage_animation.hide()
	#
#func stop_death_animation():
	#death_animation.hide()
	
func change_visibility(flag: bool):
	health_label.visible = flag
	name_label.visible = flag
