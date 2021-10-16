extends StaticBody2D

var respawn_timer_active = false

func _physics_process(delta):
	if ServerData.mining_data[self.name]["A"] == 0:
		if not respawn_timer_active:
			respawn_timer_active = true
			yield(get_tree().create_timer(ServerData.mining_data[self.name]["R"]),"timeout")
			respawn_timer_active = false
			ServerData.mining_data[self.name]["A"] = 1
			
		
