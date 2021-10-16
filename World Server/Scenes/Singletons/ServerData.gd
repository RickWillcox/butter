extends Node

const SQLite  = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "C:\\Users\\Rick\\Desktop\\mrpg\\butter\\Testing\\PlayerData.db"
var Players
var PlayerInventories
var query


var mining_data = {
	"O1":{ #Gold
		"T": "G", #type
		"TH": 3, #hits to mine
		"CT": 0, #current hits
		"R": 5, #respawn
		"A": 1 #active
	},
	"O2":{
		"T": "S",
		"TH": 3,
		"CT": 0,
		"R": 5,
		"A": 1
	},
	"O3":{
		"type": "T",
		"TH": 3,
		"CT": 0,
		"R": 5,
		"A": 1
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
