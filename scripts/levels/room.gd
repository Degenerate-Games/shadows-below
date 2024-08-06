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
