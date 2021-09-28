extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path = "res://Data/PlayerLoginData"
var PlayerIDs

func _ready():
	dbRefreshDatabase()	
	dbCheckUniqueUsername("ricky")


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
	var result
	for i in range(0, PlayerIDs.size()):
		print(str(username) + " " + PlayerIDs[i]["username"])
		if PlayerIDs[i]["username"] == username:
			print("username found in db")
			print(PlayerIDs[i]["salt"])
			return [true, username, PlayerIDs[i]["password"], PlayerIDs[i]["salt"]]
		else:
			result = [false, null, null, null]
	return result

func dbRefreshDatabase():
	db = SQLite.new()
	db.path = db_path
	db.open_db()
	var table_name = "PlayerLoginData"
	db.query("select * from " + table_name + ";")
	PlayerIDs = db.query_result	


