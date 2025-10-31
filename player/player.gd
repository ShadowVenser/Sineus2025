extends entity

const class_health: Dictionary = {"barbarian": 6, "warrior": 5, "rogue": 4}
const class_weapon: Dictionary = {"barbarian": "club", "warrior": "sword", "rogue": "dagger"}
const weapons: Dictionary = {"sword": {"damage": 3, "damage_type": "sever", "name": "sword"}, 
"club": {"damage": 3, "damage_type": "blunt", "name": "club"}, 
"dagger": {"damage": 2, "damage_type": "pierce", "name": "dagger"}, 
"axe": {"damage": 4, "damage_type": "sever", "name": "axe"}, 
"spear": {"damage": 3, "damage_type": "pierce", "name": "spear"}, 
"legendary_sword": {"damage": 10, "damage_type": "sever", "name": "legendary_sword"}}

var player_lvl_int: int = 0
var player_level: Dictionary = {"barbarian": 0, "warrior": 0, "rogue": 0}
var weapon: Dictionary

func create_character():
	max_health = 0
	player_lvl_int = 0
	for key in player_level.keys():
		player_level[key] = 0
	for key in abilities.keys():
		abilities[key] = false
	for stat in stats:
		stats[stat] = randi_range(1, 3)
	#print(stats, "   ")

func lvlup(class_title: String):
	player_level[class_title] += 1
	player_lvl_int += 1
	match  class_title:
		"rogue":
			match player_level["rogue"]:
				1: abilities["stealth"] = true
				2: 
					stats["agility"] += 1
					emit_signal("new_opponent_stats", stats)
				3: abilities["poison"] = true
		"warrior":
			match player_level["warrior"]:
				1: abilities["impulse"] = true
				2: abilities["shield"] = true
				3: 
					stats["strength"] += 1
					emit_signal("new_opponent_stats", stats)
		"barbarian":
			match player_level["barbarian"]:
				1: abilities["rage"] = true
				2: abilities["stone"] = true
				3: 
					stats["endurance"] += 1
					emit_signal("new_opponent_stats", stats)
	
	max_health += class_health[class_title] + stats["endurance"]
	heal()
	if player_lvl_int == 1:
		emit_signal("new_opponent_stats", stats)
		new_weapon(class_weapon[class_title])
	#print(player_level)
	#print(stats)
	health_label.text = "%d / %d" % [health, max_health]

func new_weapon(weapon_name: String): 
	weapon = weapons[weapon_name]
	#print(weapon_name, " ", weapon)
	
func heal():
	health = max_health
	health_label.text = "%d / %d" % [health, max_health]
	turn_counter = 0
	
func calc_base_damage():
	super.calc_base_damage()
	base_damage += stats["strength"] + weapon["damage"]
	weapon_damage = weapon["damage"]
	damage_type = weapon["damage_type"]
	#print(self.name, " base damage = ", base_damage)
