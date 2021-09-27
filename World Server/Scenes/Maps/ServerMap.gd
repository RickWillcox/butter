extends Node2D


var enemy_spawn = preload("res://Scenes/ServerEnemy.tscn")
var melee_attack = preload("res://Scenes/Player/Melee_Attack.tscn")

# warning-ignore:unused_argument

func SpawnEnemy(enemy_id, location):
	var enemy_spawn_instance = enemy_spawn.instance()
	enemy_spawn_instance.name = str(enemy_id)
	enemy_spawn_instance.position = location
	get_node("YSort/Enemies/").add_child(enemy_spawn_instance, true)
	
func SpawnMelee(player_id, blend_position, player_position):
	var melee_attack_instance = melee_attack.instance()
	melee_attack_instance.player_id = player_id
	melee_attack_instance.position = player_position
	melee_attack_instance.change_rotation(blend_position)
	get_node("PlayerAttacks").add_child(melee_attack_instance)
	
func SpawnOre(ore_id, location):
	print("ore spawned")
	
	
	

