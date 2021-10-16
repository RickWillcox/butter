extends Node

var enemy_id_counter = 1 
var enemy_maximum = 3
var enemy_types = ["Mino"] #list of enemies that spawn
var enemy_spawn_points = [Vector2 (250, 225), Vector2 (500, 150), Vector2 (570, 470)]
var open_locations = [0,1,2]
var occupied_locations = {}
var enemy_list = {}

var ore_list = ServerData.mining_data
var ore_types = ["G"]

func _ready(): 
	var timer = Timer.new()
	timer.wait_time = 1
	timer.autostart = true
	timer.connect("timeout", self, "SpawnEnemy")
	self.add_child(timer)

func _physics_process(delta: float):
		UpdateEnemyPosition(name)
			
func SpawnEnemy():
	if enemy_list.size() >= enemy_maximum:
		pass #maximum enemies already on the map
	else:
		randomize()
		var type = enemy_types[randi() % enemy_types.size()] #select random enemy
		var rng_location_index = randi() % open_locations.size()
		var location = enemy_spawn_points[open_locations[rng_location_index]]  #select random location to spawn at
		occupied_locations[enemy_id_counter] = open_locations[rng_location_index]
		open_locations.remove(rng_location_index)
		enemy_list[enemy_id_counter] = {
		 "ET": type, #EnemyType
		 "EL": location, #EnemyLocation
		 "ECH": EnemyData.enemies[type]["MaxHealth"], #EnemyCurrentHealth
		 "EMH": EnemyData.enemies[type]["MaxHealth"], #EnemyMaxHealth
		 "ES": "Idle", #EnemyState
		 "TO": 1, #time_out
		 "EAT": ""} #EAttackType
		get_parent().get_node("ServerMap").SpawnEnemy(enemy_id_counter, location, type)
		enemy_id_counter += 1
	for enemy in enemy_list.keys():
		if enemy_list[enemy]["ES"] == "Dead":
			if enemy_list[enemy]["TO"] == 0:
				enemy_list.erase(enemy)
			else:
				enemy_list[enemy]["TO"] = enemy_list[enemy]["TO"] -1

func UpdateEnemyPosition(name):
	pass
				
func EnemyMeleeHit(enemy_id, damage):
	if enemy_list[enemy_id]["ECH"] <= 0:
		pass
	else:
		enemy_list[enemy_id]["ECH"] = enemy_list[enemy_id]["ECH"] - damage
		if enemy_list[enemy_id]["ECH"] <= 0:
			get_node("/root/Server/ServerMap/YSort/Enemies/" + str(enemy_id)).queue_free()
			enemy_list[enemy_id]["ES"] = "Dead"
			open_locations.append(occupied_locations[enemy_id])
			occupied_locations.erase(enemy_id)
	
			

