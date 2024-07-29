extends Area2D

var connected_room: PackedScene

func enter():
	var room
	if not connected_room:
		room = get_parent().get_parent().generate_room()
		connected_room = PackedScene.new()
		connected_room.pack(get_parent().get_parent().generate_room())
	if not room:
		room = connected_room.instantiate()
	get_parent().queue_free()
	get_parent().get_parent().add_child(room)
	var connected_door = null
	await room.ready
	match name:
		"West Door":
			connected_door = room.get_node("East Door")
		"East Door":
			connected_door = room.get_node("West Door")
		"North Door":
			connected_door = room.get_node("South Door")
		"South Door":
			connected_door = room.get_node("North Door")
	connected_door.connected_room = PackedScene.new()
	connected_door.connected_room.pack(get_parent())
	
	var player = get_tree().get_first_node_in_group("player")
	match name:
		"West Door":
			player.global_position = get_spawn_position("East Spawn")
		"East Door":
			player.global_position = get_spawn_position("West Spawn")
		"North Door":
			player.global_position = get_spawn_position("South Spawn")
		"South Door":
			player.global_position = get_spawn_position("North Spawn")

func _on_room_complete():
	print("Room Complete")
	$Sprite2D.texture = load("res://assets/sprites/doors/temp_door_open.png")
	$CollisionShape2D.disabled = false

func get_spawn_position(spawn_name: String) -> Vector2:
	for child in connected_room.get_children():
		if child.is_in_group("player_spawn") and child.name == spawn_name:
			return child.global_position
	return Vector2()

func _on_body_entered(body: Node2D):
	print(body)
	if body.is_in_group("player"):
		enter()
