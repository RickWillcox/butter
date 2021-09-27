extends Node

var skill_data


var test_data = {
	"Stats":{
		"Strength": 42,
		"Vitality": 68,
		"Dexterity": 37,
		"Intelligence": 24,
		"Wisdom": 17
	}
}

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
	var skill_data_file = File.new()
	skill_data_file.open("res://Data/SkillData.json", File.READ)
	var skill_data_json = JSON.parse(skill_data_file.get_as_text())
	skill_data_file.close()
	skill_data = skill_data_json.result
	
	
