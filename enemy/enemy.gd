extends entity

const enemy_type: Dictionary = {"goblin": {"name": "goblin", "health": 5, "damage": 2, "strength": 1, "agility": 1, "endurance": 1, "loot": "dagger"}, 
"slime": {"name": "slime", "health": 8, "damage": 1, "strength": 3, "agility": 1, "endurance": 2, "loot": "spear"}, 
"skeleton": {"name": "skeleton", "health": 10, "damage": 2, "strength": 2, "agility": 2, "endurance": 1, "loot": "club"}, 
"ghost": {"name": "ghost", "health": 6, "damage": 3, "strength": 1, "agility": 3, "endurance": 1, "loot": "sword"}, 
"golem": {"name": "golem", "health": 10, "damage": 1, "strength": 3, "agility": 1, "endurance": 3, "loot": "axe"}, 
"dragon": {"name": "dragon", "health": 20, "damage": 4, "strength": 3, "agility": 3, "endurance": 3, "loot": "legendary_sword"} }

var enemy: Dictionary

func new_enemy():
	turn_counter = 0
	var random_key = enemy_type.keys()[randi_range(0, enemy_type.size() - 1)]
	enemy = enemy_type[random_key]
	#enemy = enemy_type["golem"]
	for key in stats.keys():
		stats[key] = enemy[key]
	#print("enemy stats: ", stats)
	emit_signal("new_opponent_stats", stats)
	max_health = enemy["health"]
	health = max_health
	#health = 100
	health_label.text = "%d / %d" % [health, max_health]
	var new_name: String
	for key in abilities.keys():
		abilities[key] = false
	match enemy["name"]:
		"goblin": new_name = "ГОБЛИН"
		"slime": 
			new_name = "СЛИЗЕНЬ"
			abilities["sever_resist"] = true
		"skeleton": 
			new_name = "СКЕЛЕТ"
			abilities["blunt_weakness"] = true
		"ghost": 
			new_name = "ПРИЗРАК"
			abilities["stealth"] = true
		"golem": 
			new_name = "ГОЛЕМ"
			abilities["stone"] = true
		"dragon": 
			new_name = "ДРАКОН"
			abilities["fire_breath"] = true
	name_label.text = new_name
	#print(enemy["name"])
	loot = enemy["loot"]
	
func take_damage(damage: int, _weapon_damage: int, _damage_type: String):
	if abilities["blunt_weakness"] and _damage_type == "blunt":
		damage = damage * 2
	if abilities["sever_resist"] and _damage_type == "sever":
		damage -= _weapon_damage
	super.take_damage(damage, _weapon_damage, _damage_type)

func calc_base_damage():
	super.calc_base_damage()
	base_damage += enemy["damage"] + stats["strength"]
	#print(self.name, " base damage = ", base_damage)
