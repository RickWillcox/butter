extends Node2D

var player_id
var blend_position
onready var animation_player = get_node("AnimationPlayer")
onready var melee_hitbox = get_node("Pivot/Area2D/MeleeHitbox")
onready var melee_attack_scene

func change_rotation(blend_position):
	var animation_tree = get_node("AnimationTree")
	animation_tree.set("parameters/Hitbox_Rotation/blend_position", blend_position)


func _on_Timer_timeout() -> void:
	queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Enemies"):
		var enemy_id = int(body.get_name())
		get_node("/root/Server/Map").EnemyMeleeHit(enemy_id, 150) #150 is damage to change later
	elif body.is_in_group("Ores"):
		if ServerData.mining_data[body.name]["active"] == true:
			if ServerData.mining_data[body.name]["current_hits"] == ServerData.mining_data[body.name]["hits_to_mine"] - 1:
				#node drops item and goes inactive
				ServerData.mining_data[body.name]["active"] = false
				ServerData.mining_data[body.name]["current_hits"] = 0
			else:
				ServerData.mining_data[body.name]["current_hits"] += 1

