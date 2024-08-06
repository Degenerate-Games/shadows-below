#	Copyright 2024 Degenerate Games
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#		http://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.

extends Area2D

# var connected_room: PackedScene

func enter():
	var room
	# if not connected_room:
	room = get_parent().get_parent().generate_room()
		# connected_room = PackedScene.new()
		# connected_room.pack(get_parent().get_parent().generate_room())
	# if not room:
	# 	room = connected_room.instantiate()
	get_parent().get_parent().call_deferred("add_child", room)
	get_parent().queue_free()
	# var connected_door = null
	await room.ready
	# match name:
	# 	"West Door":
	# 		connected_door = room.get_node("East Door")
	# 	"East Door":
	# 		connected_door = room.get_node("West Door")
	# 	"North Door":
	# 		connected_door = room.get_node("South Door")
	# 	"South Door":
	# 		connected_door = room.get_node("North Door")
	# connected_door.connected_room = PackedScene.new()
	# connected_door.connected_room.pack(get_parent())
	
	var player = get_tree().get_first_node_in_group("player")
	match name:
		"West Door":
			player.global_position = get_spawn_position(room, "East Spawn")
		"East Door":
			player.global_position = get_spawn_position(room, "West Spawn")
		"North Door":
			player.global_position = get_spawn_position(room, "South Spawn")
		"South Door":
			player.global_position = get_spawn_position(room, "North Spawn")

func _on_room_complete():
	$AnimatedSprite2D.play("open")
	$CollisionShape2D.disabled = false

func get_spawn_position(room: Node2D, spawn_name: String) -> Vector2:
	for child in room.get_children():
		if child.is_in_group("player_spawn") and child.name == spawn_name:
			return child.global_position
	return Vector2()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		enter()
