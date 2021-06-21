extends Node

#Server Config
var _server = WebSocketServer.new()
var _write_mode = WebSocketPeer.WRITE_MODE_TEXT
var _use_multiplayer = false
var last_connected_client = 0
var _clients = {}
var _consumers = []
const PORT = 8080

#User Config
var mode = ''
var delay = 1
var timer

var next_packet = {}

#Event Signals
func _init():
	_server.connect("client_connected", self, "_client_connected")
	_server.connect("client_disconnected", self, "_client_disconnected")
	_server.connect("client_close_request", self, "_client_close_request")
	_server.connect("data_received", self, "_client_receive")
	_server.connect("peer_packet", self, "_client_receive")
	_server.connect("peer_disconnected", self, "_client_disconnected")

#Launch the Server on starup
func _ready():
	next_packet = Interpreter._OUTPUT
	
	_server.listen(PORT, PoolStringArray(), _use_multiplayer)
	print("Server listening in port: ", PORT)

#Active listen for packets
# warning-ignore:unused_argument
func _process(delta):
	#print(next_packet)
	if _server.is_listening():
		_server.poll()
		
	if mode == 'frame':
		_notify_consumers()

#Manage connections
# warning-ignore:unused_argument
func _client_connected(id, protocol):
	print("Client ", id, " connected")
	_clients[id] = _server.get_peer(id)
	_clients[id].set_write_mode(_write_mode)
	last_connected_client = id

func _client_close_request(id , code, reason):
	print("Client ", id, " wants to disconnect. ", code, " ", reason)

func _client_disconnected(id, clean):
	if _clients.has(id):
		_clients.erase(id)
		print("Client ", id, " disconnected. Clean: ", clean)
	
	if _consumers.has(id):
		_consumers.erase(id)

#Manage input data
func _client_receive(id):
	var packet = _server.get_peer(id).get_packet()
	var text = packet.get_string_from_utf8()
	print("Packet from client ", id, ": ", text)
	 
	Interpreter.translate(text, id)

#Manage output data
func send_data(id ,choice):
	_server.get_peer(id).put_packet(choice)

#Shutdown
func stop():
	_server.stop()

#Notify all consumers
func _notify_consumers():
	for peer in _clients:
		send_data(peer, to_json(next_packet).to_utf8())

#Notify by seconds
func _set_delay(secs):
	#TODO: Stop timer if there are no peers subscribed
	if timer == null:
		timer = Timer.new()
		timer.connect("timeout", self, "_seconds")
		timer.wait_time = secs
		add_child(timer)
	else:
		timer.stop()
		timer.wait_time = secs
	
	timer.start()

func _seconds():
	if mode == 'sec':
		_notify_consumers()
		
#Notify on jump state
func event_jump():
	if mode == 'jump':
		_notify_consumers()

