extends Node

var acting = false

#HTTP Status Template
var _OK = {
	"responseType": "OK",
	"code": 200,
	"data": {
		"message": "Request Succesful"
	}
}

var _FAILURE = {
	"responseType": "FAILED",
	"code": 500,
	"data": {
		"message": "Internal Server Error"
	}
}

var _WRONG_REQUEST = {
	"responseType": "FAILED",
	"code": 400,
	"data": {
		"message": "BAD REQUEST: Missing argument "
	}
}

#Data output template
var _OUTPUT = {
	"responseType": "OUTPUT",
	"code": 400,
	"data": {
		"player": {
			"state": "idle",
			"x": 0,
			"y": 0,
		},
		"sight": [
			{
				"name": "",
				"x": 0,
				"y": 0,
			},
			{
				"name": "",
				"x": 0,
				"y": 0,
			},
		],
		"limits": {
			"right": 0,
			"left": 0,
		},
		"money": 0,
		"screen": {}
	}
}

func notify_bad_request(id, error):
	var custom_failure = _WRONG_REQUEST
	custom_failure.data["message"] += error
	Server.send_data(id, to_json(custom_failure).to_utf8())

#Delegate Function
func translate(msg, id):
	var dic = {}
	dic = parse_json(msg)
	#TODO: Handle bad request by checking fields
	var action = dic["req"]
	
	#print("Requested action: " + action)
	if action == "jump":
		if dic.has("payload"):
			if dic.payload.has("angle"):
				var targetJump = dic.payload.angle
				Global.Player.jump(targetJump)
			else:
				notify_bad_request(id, "angle")
		else:
			Input.action_press("ac_tap")
			
	elif action == "reset":
		ReplayManager.add_step("reset")
		reset_game()
		
	elif action == "config":
		reset_game()
		if dic.has("payload"):
			var mode = dic.payload.mode
			
			Server.mode = mode
			if mode == "sec":
				Server._set_delay(dic.payload.delay)
		
			if dic.payload.has("speed"):
				Engine.time_scale = dic.payload.speed
			
			if dic.payload.has("replay_path"):
				print("SAVING REPLAY...")
				ReplayManager.start_replay(dic.payload.replay_path, dic.payload)
				
			Global.start_time()
			Server.send_data(id, to_json(_OK).to_utf8())
			
			if Server.mode == "jump":
				Server.event_jump()
		else:
			notify_bad_request(id, "payload")

func reset_game():
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	
	
#Packet Manager
func packet_factory(section, variable, data):
	if (variable != null):
		Server.next_packet["data"][section][variable] = data
	else:
		Server.next_packet["data"][section] = data
	
