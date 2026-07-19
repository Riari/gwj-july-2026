class_name InputUtils

static func get_key_display_names(action_name: String) -> Array[String]:
	var names: Array[String] = []
	for event in InputMap.action_get_events(action_name):
		if event is InputEventKey:
			names.append(OS.get_keycode_string(event.physical_keycode))
	return names

static func get_joypad_display_names(action_name: String) -> Array[String]:
	var names: Array[String] = []
	for event in InputMap.action_get_events(action_name):
		if event is InputEventJoypadButton:
			names.append(event.as_text())
	return names