extends Area2D

var connected_room: Node2D

func enter():
	if not connected_room:
		connected_room = get_parent().get_parent().generate_room()
	connected_room.show()
	connected_room.bake_after(2)
	get_parent().hide()
	var player = get_tree().get_first_node_in_group("player")
	match name:
		"West Door":
			player.global_position = get_tree().get_nodes_in_group("player_spawn").bsearch_custom("East Spawn", func (a, b) -> int: return a.name.compare_to(b))
		"East Door":
			player.global_position = get_tree().get_nodes_in_group("player_spawn").bsearch_custom("West Spawn", func (a, b) -> int: return a.name.compare_to(b))
		"North Door":
			player.global_position = get_tree().get_nodes_in_group("player_spawn").bsearch_custom("South Spawn", func (a, b) -> int: return a.name.compare_to(b))
		"South Door":
			player.global_position = get_tree().get_nodes_in_group("player_spawn").bsearch_custom("North Spawn", func (a, b) -> int: return a.name.compare_to(b))

func _on_room_complete():
	$CollisionShape2D.disabled = false

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		enter()
