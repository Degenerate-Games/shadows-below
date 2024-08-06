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

extends Resource

class_name Global

static func get_first_child_in_group(parent: Node, group: String) -> Node:
	for child in parent.get_children():
		if child.is_in_group(group):
			return child
	return null

static func get_children_in_group(parent: Node, group: String) -> Array[Node]:
	var children = []
	for child in parent.get_children():
		if child.is_in_group(group):
			children.append(child)
	return children
