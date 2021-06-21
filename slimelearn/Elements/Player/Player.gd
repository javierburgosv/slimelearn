extends KinematicBody2D

enum state {idle, jump, fall, wall}
var currentState

var motion = Vector2()
export var grav = 100
export var salto = 120
export var rot = 200
export var gravRatio = 1.5

var invdir = false

export(bool) var wallJump
export(int) var doubleJump

var rebote = motion.x

var sight

#Deshacer Saltos
var lastPos: Vector2

func _init():
	Global._setPlayer(self)
	
func _ready():
	currentState = state.idle
	initPowerUps()
	
	if Server.mode == "jump":
		Server.event_jump()

func _process(delta):
	animate()
	_player_output()
		
	if currentState == state.idle or currentState == state.wall:
		$ArrowContainer.visible = true
		$ArrowContainer.rotation_degrees = arotation($ArrowContainer.rotation_degrees, delta)
	else:
		$ArrowContainer.visible = false

func _physics_process(delta):
	
	if currentState != state.wall:
		motion.y += gravRatio * grav * delta
		motion = move_and_slide(motion, Vector2(0,-1))
	
	if motion.y > 0:
		currentState = state.fall
	elif motion.y < 0:
		currentState = state.jump
		
	if motion.x < 0:
		$Skin.flip_h = true
	elif motion.x > 0:
		$Skin.flip_h = false
	
	if is_on_ceiling() and currentState == state.jump:
		AudioStreamManager.play("res://Sound/wallhit.wav")
	
	if is_on_floor():
		doubleJump = Global.doubleJump
		
		motion.x = 0
		motion.y = 0
		
		if currentState != state.idle:
			$ArrowContainer.rotation_degrees = 0
			currentState = state.idle
			AudioStreamManager.play("res://Sound/floorhit.wav")
			
			Server.event_jump()
		
		if Input.is_action_just_pressed("ac_tap"):
			jump($ArrowContainer.rotation_degrees)
			
	if is_on_wall() and wallJump:
		doubleJump = Global.doubleJump
		
		if currentState != state.wall:
			if $Skin.flip_h == false:
				$ArrowContainer.rotation_degrees = -90
				invdir = true
			else:
				$ArrowContainer.rotation_degrees = 90
				invdir = false
			currentState = state.wall
			AudioStreamManager.play("res://Sound/stick.wav")
			
		motion.x = 0
		motion.y = 0
			
		if Global.gstate == Global.gstates.playing:
			if Input.is_action_just_pressed("ac_tap"):
				jump($ArrowContainer.rotation_degrees)
				
	if !is_on_wall() and !is_on_floor():
		if Input.is_action_just_pressed("ac_tap") and Global.gstate == Global.gstates.playing:
			jump($ArrowContainer.rotation_degrees)
	
	if currentState == state.jump or currentState == state.fall:
		if is_on_wall() and !wallJump:
			motion.x = -rebote/2
			rebote = -rebote
			AudioStreamManager.play("res://Sound/wallhit.wav")
		
	
#Arrow
func arotation(val, delta):
	if invdir:
		val = val + rot * delta
	else:
		val = val - rot * delta
	return val

func _on_ArrowContainer_body_entered(body):
	if body != null:
		invdir = !invdir
		
func jump(rota):
	if doubleJump != 0:
		
		if is_on_floor():
			lastPos = global_position
		
		AudioStreamManager.play("res://Sound/jump.wav")
		currentState = state.jump
	
		var x = sin(deg2rad(rota))
		var y = cos(deg2rad(rota))
		
		motion.x = x * salto
		motion.y = y * -salto
		doubleJump -= 1
		rebote = motion.x
		
		ReplayManager.add_step("jump", rota)
		
#Animations
func animate():
	if currentState == state.idle:
		$Skin.play("default")
	elif currentState == state.jump:
		$Skin.play("jumpUp")
	elif currentState == state.fall:
		$Skin.play("jumpDown")
	elif currentState == state.wall:
		$Skin.play("wall")

func nockback(energy):
	motion.y = energy.y
	motion.x = energy.x

func initPowerUps():
	wallJump = Global.wallJump
	doubleJump = Global.doubleJump

#Undo Jump
func _setPlayerPos(pos: Vector2):
	self.global_position = pos

#Prepare player's data to send to the clients
func _player_output():
	Interpreter.packet_factory("player", "x", self.global_position.x)
	Interpreter.packet_factory("player", "y", self.global_position.y)
	Interpreter.packet_factory("player", "state", currentState)
	Interpreter.packet_factory("player", "arrow_degrees", $ArrowContainer.rotation_degrees)
