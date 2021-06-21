extends Node

var PATH: String
var file_name: String
var file_index: int

func _ready():
	#Call when configured instead
	file_name = "replay"
	file_index = 0

func start_replay(folder, configuration):
	var file = File.new()
	
	#Checks if the filename already exists and ad a number behind
	while file.file_exists(folder + "/" + file_name + str(file_index) + ".json"):
		file_index += 1
		
	PATH = folder + "/" + file_name + str(file_index) + ".json"
	file.open(PATH, File.WRITE)
	
	var dict = {
		"doc_type": "SlimeLearn Agent Replay",
		"date": OS.get_date(),
		"config": configuration,
		"run": []
	}
	
	file.store_string(to_json(dict))
	file.close()
	
func add_step(action, degrees = null):
	
	var file = File.new()
	
	if not file.file_exists(PATH):
		return
	
	file.open(PATH, File.READ_WRITE)
	
	var replay = parse_json(file.get_as_text())
	var action_list = replay.run
	
	var dict = {
		"action": action,
		"run_time": Global.run_time,
	}
	
	if action == "jump":
		dict["angle"] = degrees
	
	action_list.append(dict)
	replay.run = action_list
	
	file.store_string(to_json(replay))
	file.close()

