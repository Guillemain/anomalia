extends Node

# My jam Canonical Input

var canonical_input = {
	"action1" : [KEY_G,KEY_K,KEY_SPACE,KEY_SHIFT],
	"action2" : [KEY_H,KEY_L],
	"left" : [KEY_A,KEY_LEFT],
	"right" : [KEY_D,KEY_RIGHT],
	"up" : [KEY_W,KEY_UP],
	"down" : [KEY_S,KEY_DOWN]
}

func add_action(action_name : String, keycode : int):
	# Simple func for addingin input.
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	var event := InputEventKey.new()
	event.physical_keycode = keycode
	InputMap.action_add_event(action_name, event)

func _init():
	for action in canonical_input:
		for keycode in canonical_input[action]:
			add_action(action,keycode)

