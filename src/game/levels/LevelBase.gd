extends Node

#
# Base level logic
#

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	pass
	
func _on_light_state_changed():
	if global.lightState == global.PlayerLightState.DARK:
		# Let's switch to dark mode
		pass
	else:
		# Let's switch to light mode
		pass
	pass
