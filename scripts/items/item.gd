class_name Item
extends Resource

enum ItemType { SHADOW, HEALTH, AURA, POWERUP }

@export var scene: PackedScene
@export_range(0, 1) var drop_rate: float
