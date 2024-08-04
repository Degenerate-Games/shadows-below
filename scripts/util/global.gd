extends Resource

class_name Global

enum COLLECTIBLE_TYPE {
	SHADOW,
	HEALTH,
	AURA,
	POWERUP
}

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
