extends Node

#
# Base level logic
#

func _ready():
	_setLightMode(global.lightState)

func _process(delta):
	
	pass

func _setLightMode(mode):
	if (mode == global.PlayerLightState.DARK):
		$LightLayer.visible = false
		$LightLayer.collision_layer = 9
		$LightLayer.collision_mask = 0
		$DarkLayer.visible = true
		$DarkLayer.collision_layer = 1
		$DarkLayer.collision_mask = 1
	else:
		$LightLayer.visible = true
		$LightLayer.collision_layer = 1
		$LightLayer.collision_mask = 1
		$DarkLayer.visible = false
		$DarkLayer.collision_layer = 9
		$DarkLayer.collision_mask = 0
	$Player/Lantern.setLightMode(mode)


func _on_Game_LightModeChanged(new_mode):
	_setLightMode(new_mode);
