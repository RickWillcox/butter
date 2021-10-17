extends Node2D

var enemy_spawn
var slime = preload("res://Scenes/Enemies/Slime.tscn")
var mino = preload("res://Scenes/Enemies/Mino.tscn")
var player_spawn = preload("res://Scenes/Player/PlayerTemplate.tscn")
var client_player = preload("res://Scenes/Player/Player.tscn")
var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100
var printed_world_state = false

func SpawnSelf():
	var client_player_instance = client_player.instance()
	client_player_instance.position = Vector2(250,250)
	get_node("YSort").add_child(client_player_instance)

func SpawnNewPlayer(player_id, spawn_position):
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		if not get_node("YSort/OtherPlayers").has_node(str(player_id)):
			var new_player = player_spawn.instance()
			new_player.position = spawn_position
			new_player.name = str(player_id)
			get_node("YSort/OtherPlayers").add_child(new_player)
#
func SpawnNewEnemy(enemy_id, enemy_dict):
	var enemy_type = enemy_dict["ET"]
	if enemy_type == "Slime":
		 enemy_spawn = slime
	elif enemy_type == "Mino":
		enemy_spawn = mino
	var new_enemy = enemy_spawn.instance()
	new_enemy.position = enemy_dict["EL"]
	new_enemy.max_hp = enemy_dict["EMH"]
	new_enemy.current_hp = enemy_dict["ECH"]
	new_enemy.type = enemy_dict["ET"]
	new_enemy.state = enemy_dict["ES"]
	new_enemy.name = str(enemy_id)
	if new_enemy.current_hp > 0:
		get_node("YSort/Enemies/").add_child(new_enemy, true)

func DespawnPlayer(player_id):
	yield(get_tree().create_timer(0.3), "timeout")
	print(player_id)
	get_node("YSort/OtherPlayers/" + str(player_id)).queue_free()

func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)
		
func _physics_process(_delta):
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove(0)
			
		if world_state_buffer.size() > 2:
			var inperpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[0]["T"])
			for player in world_state_buffer[2].keys():
				if str(player) == "T":
					continue
				if str(player) == "E":
					continue
				if str(player) == "O":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[1].has(player):
					continue
				if get_node("YSort/OtherPlayers").has_node(str(player)):
					var new_position = lerp(world_state_buffer[1][player]["P"], world_state_buffer[2][player]["P"], inperpolation_factor)
					var animation_vector = world_state_buffer[2][player]["A"]
					get_node("YSort/OtherPlayers/" + str (player)).MovePlayer(new_position, animation_vector)
				else:
					print("spawning other player")
					SpawnNewPlayer(player, world_state_buffer[2][player]["P"])
			for enemy in world_state_buffer[2]["E"].keys(): 
				if not world_state_buffer[1]["E"].has(enemy): #if you find enemy in this world state but wasnt in previous world state (15ms before) do nothing #15 10:00
					continue
				if get_node("YSort/Enemies").has_node(str(enemy)): #does enemy exist
					var new_position = lerp(world_state_buffer[1]["E"][enemy]["EL"], world_state_buffer[2]["E"][enemy]["EL"], inperpolation_factor)
					get_node("YSort/Enemies/" + str(enemy)).MoveEnemy(new_position)
					get_node("YSort/Enemies/" + str(enemy)).Health(world_state_buffer[1]["E"][enemy]["ECH"])
				else:
					SpawnNewEnemy(enemy, world_state_buffer[2]["E"][enemy])
					
			for ore in world_state_buffer[2]["O"].keys():
				if world_state_buffer[2]["O"][ore]["A"] == 0:
					get_node("YSort/Ores/" + str(ore) + "/Sprite").frame = 0
				else:
					get_node("YSort/Ores/" + str(ore) + "/Sprite").frame = 1 
								
		elif render_time > world_state_buffer[1].T: #we have no future world state
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
			for player in world_state_buffer[1].keys():		
				if str(player) == "T":
					continue
				if str(player) == "E":
					continue
				if str(player) == "O":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[0].has(player):
					continue
				if get_node("YSort/OtherPlayers").has_node(str(player)):		
					var position_delta = (world_state_buffer[1][player]["P"] - world_state_buffer[0][player]["P"])
					var new_position = world_state_buffer[1][player]["P"] + (position_delta * extrapolation_factor)
					var animation_vector = world_state_buffer[1][player]["A"]
					get_node("YSort/OtherPlayers/" + str(player)).MovePlayer(new_position, animation_vector)
			for enemy in world_state_buffer[1]["E"].keys(): 
				if not world_state_buffer[1]["E"].has(enemy): #if you find enemy in this world state but wasnt in previous world state (15ms before) do nothing #15 10:00
					continue
				if get_node("YSort/Enemies").has_node(str(enemy)): #does enemy exist
					var position_delta = ((world_state_buffer[1]["E"][enemy]["EL"] - world_state_buffer[0]["E"][enemy]["EL"]))
					var new_position = world_state_buffer[1]["E"][enemy]["EL"] + (position_delta * extrapolation_factor)
					var state = world_state_buffer[1]["E"][enemy]["ES"]
					get_node("YSort/Enemies/" + str(enemy)).MoveEnemy(new_position)
					get_node("YSort/Enemies/" + str(enemy)).Health(world_state_buffer[1]["E"][enemy]["ECH"])
				else:
					SpawnNewEnemy(enemy, world_state_buffer[1]["E"][enemy])

