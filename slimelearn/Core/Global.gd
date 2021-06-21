extends Node

#Game Config
var sound: bool
var music: bool
var difficulty: int

#Skills
var wallJump: bool
var doubleJump: int
var money: int

#Punctuation
var diamonds = []
var score: int
var dweight: float
var hweight: float
var playery0: float

#Timer
var time0: float
var run_time: float
var times_speed: int

#Player Reference
var Player

func _ready():
	randomize()
	init_config()

func _setPlayer(player):
	Player = player

func init_config():
	sound = false
	music = false
	money = 0
	wallJump = false
	doubleJump = 1
	difficulty = 3
	diamonds = []
	
	dweight = 1
	hweight = 0.25
	playery0 = Player.global_position.y 
	
	AudioServer.set_bus_mute(1, !Global.sound)
	AudioServer.set_bus_mute(2, !Global.music)
	
# warning-ignore:unused_argument
func _process(delta):
	#Money Output
	Interpreter.packet_factory("money", null, money)
	
	#Elapsed time since configuration Output
	if time0:
		run_time = (OS.get_ticks_msec() - time0) * Engine.time_scale
	Interpreter.packet_factory("time", null, run_time)
	
	#Internal score Output
	score = (money * dweight) + ((Player.global_position.y - playery0) * -1 * hweight) 
	Interpreter.packet_factory("score", null, score)
	
	#Time Output
	Interpreter.packet_factory("run_time", null, run_time)
	
func start_time():
	time0 = OS.get_ticks_msec()
