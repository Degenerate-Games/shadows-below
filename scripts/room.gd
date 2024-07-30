extends TileMap

var keys: Array[Node2D] = []
var waiting_to_bake: bool = false

signal room_complete

func add_key(key: Node2D):
  keys.append(key)
  add_child(key)

func remove_key(key: Node2D):
  keys.erase(key)
  key.queue_free()

func _on_key_unlocked():
  if keys.all(func (key: Node2D) : return key.unlocked):
    room_complete.emit()

func bake_after(frames: int):
  if waiting_to_bake:
    return
  if get_tree() == null:
    call_deferred("bake_after", frames)
  waiting_to_bake = true
  await get_tree().create_timer(frames / Engine.max_fps).timeout
  Global.get_first_child_in_group(self, "navigation_region").bake_navigation_polygon()
  waiting_to_bake = false
