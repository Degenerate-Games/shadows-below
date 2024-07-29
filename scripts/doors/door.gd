extends Area2D

var connected_room: Node2D

func enter():
	if not connected_room:
		connected_room = get_parent().get_parent().generate_room()
	connected_room.show()
	connected_room.process_mode = PROCESS_MODE_INHERIT
	connected_room.bake_after(2)
	get_parent().hide()
	get_parent().process_mode = PROCESS_MODE_DISABLED
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
