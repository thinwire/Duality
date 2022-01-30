extends Node

func setLightMode(mode):
	if (mode == global.PlayerLightState.DARK):
		$greenLight.visible = true
		$blueLight.visible = false
	else:
		$greenLight.visible = false
		$blueLight.visible = true
