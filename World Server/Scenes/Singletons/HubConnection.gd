extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1912
#var ip = "192.99.247.42"
var ip = "127.0.0.1"

onready var gameserver = get_node("/root/Server")

func _ready():
	ConnectToServer()
	
func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();
		
func ConnectToServer():
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	#I think its failing at this point
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")	

func _OnConnectionFailed():	
	print("Failed to connect to the Game Hub server")
	
func _OnConnectionSucceeded():
	print("Successfully connected to Game Hub server")
#	gameserver.StartServer()

remote func ReceiveLoginToken(token):
	gameserver.expected_tokens.append(token)
	
