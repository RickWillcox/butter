extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://Data/PlayerLoginData"

var PlayerIDs

var player


func _ready():
#	var PlayerIDs_file = File.new()
#	PlayerIDs_file.open("res://Data/PlayerData.json", File.READ)
#	var PlayerIDs_json = JSON.parse(PlayerIDs_file.get_as_text())
#	PlayerIDs_file.close()
#	PlayerIDs = PlayerIDs_json.result
	db = SQLite.new()
	db.path = db_path
	db.open_db()
	var table_name = "PlayerLoginData"
	db.query("select * from " + table_name + ";")
	PlayerIDs = db.query_result		

func SavePlayerIDs():
	var save_file = File.new()
	save_file.open("res://Data/PlayerData.json", File.WRITE)
	save_file.store_line(to_json(PlayerIDs))
	save_file.close()
	
func dbNewPlayer(username, password, salt):
	db = SQLite.new()
	db.path = db_path
	db.open_db()
	var table_name = "PlayerLoginData"
	var dict : Dictionary = Dictionary()
	dict["username"] = str(username)
	dict["password"] = str(password)
	dict["salt"] = str(salt)
	db.insert_row(table_name, dict)
	
		
func dbCheckUniqueUsername(username):
	for i in range(0, PlayerIDs.size()):
		if PlayerIDs[i]["username"] == username:
			return true
		else:
			return false
