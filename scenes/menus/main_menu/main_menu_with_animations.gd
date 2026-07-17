extends MainMenu
## Main menu extension that animates the title and menu fading in.
## The animation can be skipped by the player with any input.

var animation_state_machine : AnimationNodeStateMachinePlayback

func intro_done() -> void:
	animation_state_machine.travel("OpenMainMenu")

func _is_in_intro() -> bool:
	return animation_state_machine.get_current_node() == "Intro"

func _event_skips_intro(event : InputEvent) -> bool:
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)

func _open_sub_menu(menu : PackedScene) -> Node:
	animation_state_machine.travel("OpenSubMenu")
	return super._open_sub_menu(menu)

func _close_sub_menu() -> void:
	super._close_sub_menu()
	animation_state_machine.travel("OpenMainMenu")

func new_game() -> void:
	var cat_select_scene = load("res://scenes/menus/cat_select_menu/cat_select_menu.tscn")
	if cat_select_scene:
		var menu = cat_select_scene.instantiate()
		menu.game_started.connect(_on_cat_select_game_started)
		menu.back_pressed.connect(_on_cat_select_back)
		sub_menu = menu
		add_child(menu)
		menu_container.hide()
		menu.hidden.connect(_close_sub_menu, CONNECT_ONE_SHOT)
		menu.tree_exiting.connect(_close_sub_menu, CONNECT_ONE_SHOT)
		sub_menu_opened.emit()
		animation_state_machine.travel("OpenSubMenu")
	else:
		print("ERROR: Failed to load cat select scene")
		load_game_scene()

func _on_cat_select_game_started() -> void:
	if not sub_menu:
		return
	sub_menu.game_started.disconnect(_on_cat_select_game_started)
	sub_menu.back_pressed.disconnect(_on_cat_select_back)
	var menu = sub_menu
	sub_menu = null
	menu.queue_free()
	menu_container.show()
	animation_state_machine.travel("OpenMainMenu")
	load_game_scene()

func _on_cat_select_back() -> void:
	_close_sub_menu()

func _input(event : InputEvent) -> void:
	if _is_in_intro() and _event_skips_intro(event):
		intro_done()
		return
	super._input(event)

func _ready() -> void:
	super._ready()
	animation_state_machine = $MenuAnimationTree.get("parameters/playback")
