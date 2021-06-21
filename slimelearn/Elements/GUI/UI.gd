extends Control

func _ready():
	_mixerUiLogic($PauseMenu/Music, !Global.music)
	_mixerUiLogic($PauseMenu/Sound, !Global.sound)
	
# warning-ignore:unused_argument
func _process(delta):
	$Money/value.bbcode_text = "[right]" + str(Global.money) + "[/right]"
	$time.bbcode_text = "[center]" + str(Global.run_time) + "[/center]"
	_mixerUiLogic($PauseMenu/Music, !Global.music)
	_mixerUiLogic($PauseMenu/Sound, !Global.sound)

#Pause Menu
func _on_Pause_button_down():
	$Pause.visible = false
	$PauseMenu.visible = true
	_uiSound()

func _on_Resume_button_down():
	$Pause.visible = true
	$PauseMenu.visible = false
	_uiSound()
	
#Sound OnOff
func _on_Sound_button_down():
	_mixerUiLogic($PauseMenu/Sound, Global.sound)
	AudioServer.set_bus_mute(1, Global.sound)
	Global.sound = !Global.sound
	_uiSound()

#Music OnOff
func _on_Music_button_down():
	_mixerUiLogic($PauseMenu/Music, Global.music)
	AudioServer.set_bus_mute(2, Global.music)
	Global.music = !Global.music
	_uiSound()
	
#Reestart
func _on_Reset_button_down():
	get_tree().quit()
	
func _mixerUiLogic(node, global):
	var on = Color(1,1,1,1)
	var off = Color(1,1,1,.3)
	
	if global:
		node.modulate = off
	else:
		node.modulate = on

func _uiSound():
	AudioStreamManager.play("res://Sound/menu.wav")
