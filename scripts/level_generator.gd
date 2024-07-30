extends Node

var tile_map: TileMap
var x_tiles: int
var y_tiles: int
var enemies: Array[PackedScene]
var room_borders: Array[Rect2i]
var obstacle_idxs: Array[int]
var objective_idxs: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map = TileMap.new()
	tile_map.y_sort_enabled = true
	tile_map.tile_set = load("res://assets/levels/dirt/dirt_tileset.tres")
	x_tiles = ceili(get_viewport().get_visible_rect().size.x / tile_map.tile_set.tile_size.x)
	y_tiles = ceili(get_viewport().get_visible_rect().size.y / tile_map.tile_set.tile_size.y)

	# Initialize enemies
	enemies = []
	enemies.append(load("res://scenes/enemies/enemy_a.tscn"))
	enemies.append(load("res://scenes/enemies/enemy_b.tscn"))

	# Initialize room borders
	room_borders = []
	room_borders.append(Rect2i(0, 0, x_tiles, 1)) # Top
	room_borders.append(Rect2i(0, 0, 1, y_tiles)) # Left
	room_borders.append(Rect2i(x_tiles - 1, 0, x_tiles, y_tiles)) # Right
	room_borders.append(Rect2i(0, y_tiles - 2, x_tiles, y_tiles)) # Bottom
	room_borders.append(Rect2i(15, 17, 24, 21)) # Color UI
	room_borders.append(Rect2i(0, y_tiles / 2 - 1, 2, y_tiles / 2 + 1)) # West Player Spawn
	room_borders.append(Rect2i(x_tiles - 2, y_tiles / 2 - 1, x_tiles, y_tiles / 2 + 1)) # East Player Spawn
	room_borders.append(Rect2i(x_tiles / 2 - 1, 0, x_tiles / 2 + 1, 2)) # North Player Spawn
	room_borders.append(Rect2i(x_tiles / 2 - 1, y_tiles - 7, x_tiles / 2 + 1, y_tiles)) # South Player Spawn

	obstacle_idxs = []
	obstacle_idxs.append(1)
	obstacle_idxs.append(2)
	obstacle_idxs.append(3)

	objective_idxs = []
	objective_idxs.append(4)
	

func generate_room(difficulty: int) -> TileMap:
	var room = tile_map.duplicate()
	room.name = "Generated Room: " + str(randi())
	room.add_to_group("navigation", true)
	room.set_script(load("res://scripts/room.gd"))
	
	# Fill the room with background tiles
	print("Drawing Background")
	for x in range(x_tiles):
		for y in range(y_tiles):
			room.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 4))
	
	# Draw room frame
	print("Drawing Room Frame")
	room.set_pattern(0, Vector2i(0, 0), tile_map.tile_set.get_pattern(0))

	# Place player spawn points
	print("Placing Player Spawns")
	var player_spawn = Node2D.new()
	player_spawn.add_to_group("player_spawn")
	player_spawn.name = "West Spawn"
	player_spawn.position = Vector2i(2, y_tiles / 2) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	room.add_child(player_spawn.duplicate())
	player_spawn.name = "East Spawn"
	player_spawn.position = Vector2i(x_tiles - 3, y_tiles / 2) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	room.add_child(player_spawn.duplicate())
	player_spawn.name = "North Spawn"
	player_spawn.position = Vector2i(x_tiles / 2, 2) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	room.add_child(player_spawn.duplicate())
	player_spawn.name = "South Spawn"
	player_spawn.position = Vector2i(x_tiles / 2, y_tiles - 8) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	room.add_child(player_spawn)

	# Place the player
	print("Placing Player")
	var player = get_tree().get_first_node_in_group("player")
	player.position = player_spawn.position
	
  # Place objectives
	print("Placing Objectives")
	var obstacles: Array[Rect2i] = []
	var key_tiles: Array[Vector2i] = []
	var iterations = 0
	var objective_max = max(1, round(difficulty *.25))
	while obstacles.size() < objective_max && iterations < 10000:
		var pattern = tile_map.tile_set.get_pattern(objective_idxs.pick_random())
		var half_pattern_size = pattern.get_size() / 2.0
		var obstacle = get_pattern_rect(Vector2(randi_range(0, x_tiles), randi_range(0, y_tiles)), half_pattern_size)
		if obstacles.any(func(o): return o.intersects(obstacle)) || room_borders.any(func(b): return b.intersects(obstacle)):
			continue
		room.set_pattern(0, obstacle.position + Vector2i(1, 1), pattern)
		if pattern.has_cell(Vector2i(3, 4)):
			if pattern.get_cell_atlas_coords(Vector2i(3, 4)) == Vector2i(3, 1):
				key_tiles.append(Vector2i(obstacle.position + Vector2i(4, 5)))
		obstacles.append(obstacle)
		iterations += 1

	# Place some obstacles
	print("Placing Obstacles")
	iterations = 0
	while obstacles.size() < difficulty && iterations < 1000:
		for x in range(x_tiles):
			for y in range(y_tiles):
				if randf() < 0.01:
					var pattern = tile_map.tile_set.get_pattern(obstacle_idxs.pick_random())
					var half_pattern_size = pattern.get_size() / 2.0
					var obstacle = get_pattern_rect(Vector2(x, y), half_pattern_size)
					if obstacles.any(func(o): return o.intersects(obstacle)) || room_borders.any(func(b): return b.intersects(obstacle)):
						continue
					room.set_pattern(0, obstacle.position + Vector2i(1, 1), pattern)
					obstacles.append(obstacle)
		iterations += 1
	
	# Place Keys
	print("Placing Keys")
	for key_tile in key_tiles:
		var key = load("res://scenes/items/key_light.tscn").instantiate()
		key.position = key_tile * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
		print ("Key Tile: ", key_tile, "Key Position: ", key.position)
		key.key_unlocked.connect(room._on_key_unlocked)
		room.add_key(key)
	
	# Place doors
	print("Placing Doors")
	var door = load("res://scenes/doors/door_a.tscn").instantiate()
	room.room_complete.connect(door._on_room_complete)
	door.position = Vector2i(0, y_tiles / 2) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	door.name = "West Door"
	room.add_child(door)
	door = load("res://scenes/doors/door_a.tscn").instantiate()
	room.room_complete.connect(door._on_room_complete)
	door.rotate(PI)
	door.position = Vector2i(x_tiles - 1, y_tiles / 2) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	door.name = "East Door"
	room.add_child(door)
	door = load("res://scenes/doors/door_a.tscn").instantiate()
	room.room_complete.connect(door._on_room_complete)
	door.rotate(PI / 2)
	door.position = Vector2i(x_tiles / 2, 0) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	door.name = "North Door"
	room.add_child(door)
	door = load("res://scenes/doors/door_a.tscn").instantiate()
	room.room_complete.connect(door._on_room_complete)
	door.rotate(-PI / 2)
	door.position = Vector2i(x_tiles / 2, y_tiles - 6) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	door.name = "South Door"
	room.add_child(door)

	# Add pause menu
	print("Adding Pause Menu")
	var pause_menu = load("res://scenes/menus/pause_menu.tscn").instantiate()
	room.add_child(pause_menu)

	# Set up navigation
	var navigation = NavigationRegion2D.new()
	navigation.name = "Navigation"
	navigation.add_to_group("navigation_region", true)
	navigation.navigation_polygon = load("res://assets/levels/navigation_polygon.tres")
	room.add_child(navigation)

	return room

func get_pattern_rect(position: Vector2, half_pattern_size: Vector2) -> Rect2i:
	var obstacle = Rect2i(floor(position - half_pattern_size - Vector2(1, 1)), half_pattern_size * 2 + Vector2(1, 1))
	
	# Make sure the obstacle is within the room
	if obstacle.position.x < 0:
		obstacle.position.x = abs(obstacle.position.x)
	
	if obstacle.position.y < 0:
		obstacle.position.y = abs(obstacle.position.y)

	return obstacle
