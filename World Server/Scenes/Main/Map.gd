extends Node

var enemy_id_counter = 1 
var enemy_maximum = 3
var enemy_types = ["Slime", "Mino"] #list of enemies that spawn
var enemy_spawn_points = [Vector2 (250, 225), Vector2 (500, 150), Vector2 (570, 470)]
var open_locations = [0,1,2]
var occupied_locations = {}
var enemy_list = {}

var ore_list = ServerData.mining_data
var ore_types = ["Gold Ore"]

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
		enemy_list[enemy_id_counter] = {"EnemyType": type, "EnemyLocation": location, "EnemyCurrentHealth": EnemyData.enemies[type]["MaxHealth"], "EnemyMaxHealth": EnemyData.enemies[type]["MaxHealth"], "EnemyState": "Idle", "time_out": 1}
		get_parent().get_node("ServerMap").SpawnEnemy(enemy_id_counter, location, type)
		enemy_id_counter += 1
	for enemy in enemy_list.keys():
		if enemy_list[enemy]["EnemyState"] == "Dead":
			if enemy_list[enemy]["time_out"] == 0:
				enemy_list.erase(enemy)
			else:
				enemy_list[enemy]["time_out"] = enemy_list[enemy]["time_out"] -1

func UpdateEnemyPosition(name):
	if enemy_list.size() > 2:
		print(enemy_list[name])
	pass
				
func EnemyMeleeHit(enemy_id, damage):
	if enemy_list[enemy_id]["EnemyCurrentHealth"] <= 0:
		pass
	else:
		enemy_list[enemy_id]["EnemyCurrentHealth"] = enemy_list[enemy_id]["EnemyCurrentHealth"] - damage
		if enemy_list[enemy_id]["EnemyCurrentHealth"] <= 0:
			get_node("/root/Server/ServerMap/YSort/Enemies/" + str(enemy_id)).queue_free()
			enemy_list[enemy_id]["EnemyState"] = "Dead"
			open_locations.append(occupied_locations[enemy_id])
			occupied_locations.erase(enemy_id)
			

