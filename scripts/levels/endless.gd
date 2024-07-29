extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(LevelGenerator.generate_room(5))

func _process(_delta):
	if Input.is_action_just_pressed("reload"):
		var room = get_child(-1)
		if room.name.begins_with("Generated Room"):
			room.queue_free()
			add_child(LevelGenerator.generate_room(5))
	if Input.is_action_just_pressed("bake"):
		get_tree().call_group("navigation_region", "bake_navigation_polygon")
