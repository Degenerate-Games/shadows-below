extends Resource

class_name Item

enum ITEM_TYPE {
	SHADOW,
	HEALTH,
	AURA,
	POWERUP
}

@export var scene: PackedScene
@export_range(0, 1) var drop_rate: float