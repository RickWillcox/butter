extends Node

const SQLite  = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "C:\\Users\\Rick\\Desktop\\mrpg\\butter\\Testing\\PlayerData.db"
var Players
var PlayerInventories
var query


var mining_data = {
	"Ore1":{
		"type": "Gold",
		"hits_to_mine": 3,
		"current_hits": 0,
		"respawn": 5,
		"active": true
	},
	"Ore2":{
		"type": "Silver",
		"hits_to_mine": 3,
		"current_hits": 0,
		"respawn": 5,
		"active": true
	},
	"Ore3":{
		"type": "Tin",
		"hits_to_mine": 3,
		"current_hits": 0,
		"respawn": 5,
		"active": true
	}
}


func _ready():
	query()
	print(query)
	
func RefreshPlayers():
	db = SQLite.new()
	db.path = db_path
	db.open_db()
	db.query("select * from Players")
	Players = db.query_result

func RefreshPlayerInventories():
	db = SQLite.new()
	db.path = db_path
	db.open_db()
	db.query("select * from PlayerInventories")
	PlayerInventories = db.query_result 
	
func query():
	db = SQLite.new()
	db.path = db_path
	db.open_db()
	db.query("select * from Players left join PlayerInventories on Players.id = PlayerInventories.player_id where Players.player_name = 'rick'")
	query = db.query_result
