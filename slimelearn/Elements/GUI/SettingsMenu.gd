extends TextureRect

func _ready():
	_mixerUiLogic($Music2, !Global.music)
	_mixerUiLogic($Sound2, !Global.sound)
	_updateDif()
	
# warning-ignore:unused_argument
func _process(delta):
	_mixerUiLogic($Music2, !Global.music)
	_mixerUiLogic($Sound2, !Global.sound)
	
func _on__button_down():
	if Global.difficulty > 1:
		Global.difficulty -= 1
		_updateDif()

func _on_plus_button_down():
	if Global.difficulty < 3:
		Global.difficulty += 1
		_updateDif()
		
func _updateDif():
	if Global.difficulty == 1:
		$Section/Indicator.text = "Easy"
		Global.Player.rot = 133
		$"Section/+".modulate = Color(1,1,1,1)
		$"Section/-".modulate = Color(1,1,1,.3)
		AudioStreamManager.play("res://Sound/menu.wav")
	elif Global.difficulty == 2:
		$Section/Indicator.text = "Normal"
		Global.Player.rot = 166
		$"Section/+".modulate = Color(1,1,1,1)
		$"Section/-".modulate = Color(1,1,1,1)
		AudioStreamManager.play("res://Sound/menu.wav")
	elif Global.difficulty == 3:
		$Section/Indicator.text = "Hard"
		Global.Player.rot = 200
		$"Section/-".modulate = Color(1,1,1,1)
		$"Section/+".modulate = Color(1,1,1,.3)
		AudioStreamManager.play("res://Sound/menu.wav")
		


func _on_Sound2_button_down():
	_mixerUiLogic($Sound2, Global.sound)
	AudioServer.set_bus_mute(1, Global.sound)
	Global.sound = !Global.sound
	AudioStreamManager.play("res://Sound/menu.wav")


func _on_Music2_button_down():
	_mixerUiLogic($Music2, Global.music)
	AudioServer.set_bus_mute(2, Global.music)
	Global.music = !Global.music
	AudioStreamManager.play("res://Sound/menu.wav")

func _mixerUiLogic(node, global):
	var on = Color(1,1,1,1)
	var off = Color(1,1,1,.3)
	
	if global:
		node.modulate = off
	else:
		node.modulate = on
