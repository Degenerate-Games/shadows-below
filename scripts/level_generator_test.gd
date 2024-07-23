extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(LevelGenerator.generate_room(5))
