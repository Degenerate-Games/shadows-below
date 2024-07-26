extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(LevelGenerator.generate_room(5))

func _process(_delta):
	if Input.is_action_just_pressed("reload"):
		var last_child = get_child(-1)
		if last_child.name.begins_with("Generated Room"):
			last_child.queue_free()
			add_child(LevelGenerator.generate_room(5))
