extends Node2D
class_name Enemy

signal deal_damage(_damage: int)
signal enemy_is_dead()

const enemy_type: Dictionary = {"goblin": {"name": "goblin", "health": Vector2(5,7), "damage": Vector2(1,3)}, 
"slime": {"name": "slime", "health": Vector2(8,10), "damage": Vector2(1,3)}, 
"gnome": {"name": "gnome", "health": Vector2(10,12), "damage": Vector2(2,4)}, 
"ghost": {"name": "ghost", "health": Vector2(6,8), "damage": Vector2(2,3)}, 
"golem": {"name": "golem", "health": Vector2(12,14), "damage": Vector2(3,5)}, 
"dragon": {"name": "dragon", "health": Vector2(18,22), "damage": Vector2(4,6)}, 
"boss": {"name": "dementia", "health": Vector2(30,40), "damage": Vector2(6,8)} }

const enemy_sprites: Dictionary = {"goblin": {"sprite":  preload("res://new_enemy/sprites/Maple Tree.png"), "scale": Vector2(12,12), "position": Vector2(50,60)}, 
"golem": {"sprite":  preload("res://new_enemy/sprites/door.png"), "scale": Vector2(20,20), "position": Vector2(50,60)}, 
"gnome": {"sprite":  preload("res://new_enemy/sprites/Fence's copiar.png"), "scale": Vector2(20,20), "position": Vector2(50,200)}, 
"ghost": {"sprite":  null, "scale": Vector2(10,10), "position": Vector2(50,60)}, 
"slime": {"sprite":  preload("res://new_enemy/sprites/Bushe1.png"), "scale": Vector2(7,7), "position": Vector2(50,150)}, 
"dragon":{"sprite":  preload("res://new_enemy/sprites/House.png"), "scale": Vector2(6.5,6.5), "position": Vector2(50,60)},
"boss": {"sprite":  preload("res://new_enemy/sprites/mirror.png"), "scale": Vector2(5,5), "position": Vector2(50,150), "name_position": Vector2(-75,-200) }}


@onready var name_label = $Control/label
@onready var health_label = $Control/health_label
@onready var damage_animation = $swing_animation
@onready var death_animation = $death_animation
@onready var damage_label = $Control/damage_lable
@onready var damage_number_animation = $Control/damage_lable/AnimationPlayer
@onready var clash_sound = $AudioStreamPlayer2D
@onready var sprite = $sprite

const sound_cash = [preload("res://sfx/sword-clash-241729.mp3"), preload("res://sfx/sword-clashhit-393837.mp3"), 
preload("res://sfx/sword-slice-2-393845.mp3"), preload("res://sfx/sword-slice-393847.mp3")]

var stats: Dictionary
var sprite_stats: Dictionary
var health: int 
var max_health: int
var base_melee_damage: int
var turn_counter: int = 0
var damage_type: String = ""
var effects: Effect = Effect.new()
var enemy_counter: int = 0

func _ready() -> void:
	health_label.text = "%d / %d" % [health, max_health]
	damage_animation.connect("animation_finished", stop_animation)
	damage_animation.hide()

func attack():
	base_melee_damage = randi_range(stats["damage"][0], stats["damage"][1])
	print("DAMAGE: ", base_melee_damage)
	var damage = (base_melee_damage - effects.get_weak_mod()) * effects.get_stun_mod()
	effects.effect_applied()
	emit_signal("deal_damage", damage)
	if damage > 0:
		damage_animation.show()
		damage_animation.play("swing")
	
func stop_animation():
	damage_animation.hide()
	
func take_damage(damage: int, effect :String = ""):
	print(damage)
	if (effect != ""):
		print(effect)
		effects.add_effect(effect)
	health -= damage + effects.get_burn_mod()
	print("Enemy takes damage ", damage)
	health_label.text = "%d / %d" % [health, max_health]
	damage_number_animation.play("moving_number")
	damage_label.text = "-" + str(damage + effects.get_burn_mod())
	if health <= 0:
		print("Enemy is dead")
		emit_signal("enemy_is_dead")
	
func change_visibility(flag: bool):
	health_label.visible = flag
	name_label.visible = flag
	
func new_enemy():
	enemy_counter += 1
	var random_key
	if enemy_counter == 7:
		random_key = "boss"
	else:
		random_key = enemy_type.keys()[randi_range(0, enemy_type.size() - 2)]
	#random_key = "boss"
	stats = enemy_type[random_key]
	sprite_stats = enemy_sprites[random_key]
	if "name_position" in sprite_stats.keys():
		$Control.position = sprite_stats["name_position"]
	#get_parent().get_node("mage").melee_animation.global_position = sprite.global_position
	sprite.texture = sprite_stats["sprite"]
	sprite.scale = sprite_stats["scale"]
	sprite.position = sprite_stats["position"]
	max_health = randi_range(stats["health"][0], stats["health"][1])
	health = max_health
	health_label.text = "%d / %d" % [health, max_health]
	name_label.text = stats["name"]
