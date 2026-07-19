class_name MedalUtils

enum Medal {
	BRONZE,
	SILVER,
	GOLD,
	NONE
}

static func medal_to_string(medal: Medal) -> String:
	match medal:
		Medal.BRONZE: return "Bronze"
		Medal.SILVER: return "Silver"
		Medal.GOLD: return "Gold"
		Medal.NONE: return "None"

	return "None"

static func get_medal_color(medal: Medal) -> Color:
	match medal:
		Medal.BRONZE: return Color(0.9, 0.6, 0.4)
		Medal.SILVER: return Color(0.8, 0.8, 0.8)
		Medal.GOLD: return Color(0.9, 0.9, 0.3)
		Medal.NONE: return Color(1.0, 1.0, 1.0)

	return Color(1.0, 1.0, 1.0)

static func get_medal_score_multiplier(medal: Medal) -> float:
	match medal:
		Medal.BRONZE: return 1.5
		Medal.SILVER: return 2.5
		Medal.GOLD: return 5.0
		Medal.NONE: return 1.0
	
	return 1.0