extends Node

#
# Base level logic
#

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	pass

func _setLightMode(mode):
	global.lightState = mode;
	if (mode == global.PlayerLightState.DARK):
		$LightLayer.visible = false;
		$DarkLayer.visible = true;
	else:
		$LightLayer.visible = true;
		$DarkLayer.visible = false;


func _on_Game_LightModeChanged(new_mode):
	_setLightMode(new_mode);
