extends Node2D

@export var character_scene: PackedScene

func _ready() -> void:
	spawn.call_deferred(character_scene.instantiate() as Character)

func spawn(character: Character) -> void:
	character.set_position(get_position())
	get_parent().add_child(character)
	var animation: AnimationComponent = character.get_component(AnimationComponent)
	if animation:
		var sprite_type := GameState.get_selected_cat()
		while sprite_type == GameState.get_selected_cat():
			sprite_type = SpriteUtils.Type.values().pick_random()

		animation.set_sprite_frames(sprite_type)
	
	print("spawned character: %s" % character.get_class())
	queue_free()
