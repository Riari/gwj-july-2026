class_name Sprites

enum Type {
	CAT_BLACK,
	CAT_GREY,
	CAT_ORANGE,
	CAT_PINK,
	CAT_SIAMESE
}

const sprite_frames: Dictionary = {
	Type.CAT_BLACK: preload("res://resources/sprite_frames/sprite_frames_cat_black.tres"),
	Type.CAT_GREY: preload("res://resources/sprite_frames/sprite_frames_cat_grey.tres"),
	Type.CAT_ORANGE: preload("res://resources/sprite_frames/sprite_frames_cat_orange.tres"),
	Type.CAT_PINK: preload("res://resources/sprite_frames/sprite_frames_cat_pink.tres"),
	Type.CAT_SIAMESE: preload("res://resources/sprite_frames/sprite_frames_cat_siamese.tres")
}