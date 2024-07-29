extends Area2D

var connected_room: Node2D

func enter():
	if not connected_room:
		return

func _on_room_complete():
	$CollisionShape2D.disabled = false