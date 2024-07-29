extends TileMap

var keys: Array[Node2D]

signal room_complete

# Called when the node enters the scene tree for the first time.
func _ready():
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass

func add_key(key: Node2D):
  keys.append(key)
  add_child(key)

func remove_key(key: Node2D):
  keys.erase(key)
  key.queue_free()

func _on_key_unlocked():
  if keys.all(func (key: Node2D) : return key.unlocked):
    room_complete.emit()
  else:
    var locked_keys = keys.filter(func (key: Node2D) : return not key.unlocked)
    var locked_ratio = locked_keys.size() / keys.size()
    # set door graphics based on locked_ratio

func bake_after(frames: int):
  await get_tree().create_timer(frames / Engine.max_fps).timeout
  Global.get_first_child_in_group(self, "navigation_region").bake_navigation_polygon()
