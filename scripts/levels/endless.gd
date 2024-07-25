extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(LevelGenerator.generate_room(5))

func _process(_delta):
	if Input.is_action_just_pressed("reload"):
		get_child(get_child_count() - 1).queue_free()
		add_child(LevelGenerator.generate_room(5))
