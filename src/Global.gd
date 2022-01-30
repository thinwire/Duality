extends Node # must extend Node

# Testing bullshit

var score := 0
var health := 0
var something := 0

# Actually necessary for tracking game states

enum PlayerLightState {
	LIGHT,
	DARK
}

export var lightState = PlayerLightState.DARK
