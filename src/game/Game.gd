extends Node

signal LightModeChanged(new_mode)

func _ready():
	
	pass

func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		var mode = 0;
		if global.lightState == global.PlayerLightState.DARK:
			mode = global.PlayerLightState.LIGHT
		else:
			mode = global.PlayerLightState.DARK
		emit_signal('LightModeChanged', mode)
		global.lightState = mode;

