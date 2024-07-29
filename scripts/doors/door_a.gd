extends Area2D


func _on_room_complete():
	$CollisionShape2D.disabled = false