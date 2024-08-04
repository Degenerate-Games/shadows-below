extends TileMap

var keys: Array[Node2D] = []
var waiting_to_bake: bool = false

signal room_complete

func _ready():
	Global.get_first_child_in_group(self, "navigation_region").bake_navigation_polygon()
	remove_from_group("navigation")

func add_key(key: Node2D):
	keys.append(key)
	add_child(key)

func remove_key(key: Node2D):
	keys.erase(key)
	key.queue_free()

func _on_key_unlocked():
	if keys.all(func (key: Node2D) : return key.unlocked):
		room_complete.emit()
