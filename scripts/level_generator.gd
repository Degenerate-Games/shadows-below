extends Node

var tile_map: TileMap
var x_tiles: int
var y_tiles: int
var enemies: Array[PackedScene]
var room_borders: Array[Rect2i]

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_map = TileMap.new()
	tile_map.add_layer(1)
	tile_map.add_layer(2)
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
	room_borders.append(Rect2i(17, 13, 22, 17)) # Player spawn
	


func generate_room(difficulty: int) -> TileMap:
	var room = tile_map.duplicate()
	room.name = "Generated Room: " + str(randi())
	room.set_script(load("res://scripts/room.gd"))

	# Add UI to scene
	print("Adding UI")
	var hud = load("res://scenes/ui/hud.tscn").instantiate()
	hud.name = "HUD"
	hud.position = Vector2(0, 0)
	room.add_child(hud)
	
	# Fill the room with background tiles
	print("Drawing Background")
	for x in range(x_tiles):
		for y in range(y_tiles):
			room.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 4))
	
	# Draw room frame
	print("Drawing Room Frame")
	room.set_pattern(1, Vector2i(0, 0), tile_map.tile_set.get_pattern(0))

	# Place the player
	print("Placing Player")
	var player = get_node("/root/Endless/Player")
	player.position = Vector2i(19, 15) * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
	get_node("/root/Endless/HUD/ColorMixingUI").color_changed.connect(player._on_color_mixing_ui_color_changed)
	player.handle_color_change(get_node("/root/Endless/HUD/ColorMixingUI").get_color())
	
	# Place some obstacles
	print("Placing Obstacles")
	var obstacles: Array[Rect2i] = []
	var key_tiles: Array[Vector2i] = []
	var iterations = 0
	while obstacles.size() < difficulty && iterations < 1000:
		for x in range(x_tiles):
			for y in range(y_tiles):
				if randf() < 0.01:
					var pattern = tile_map.tile_set.get_pattern(randi_range(1, tile_map.tile_set.get_patterns_count() - 1))
					var half_pattern_size = pattern.get_size() / 2.0
					var obstacle = get_obstacle_rect(Vector2(x, y), half_pattern_size)
					if obstacles.any(func(o): return o.intersects(obstacle)) || room_borders.any(func(b): return b.intersects(obstacle)):
						continue
					room.set_pattern(1, obstacle.position, pattern)
					if pattern.has_cell(Vector2i(3, 3)):
						if pattern.get_cell_atlas_coords(Vector2i(3, 3)) == Vector2i(3, 1):
							key_tiles.append(Vector2i(x, y))
					obstacles.append(obstacle)
		iterations += 1
	
	# Place some enemies
	print("Placing Enemies")
	var enemy_tiles: Array[Vector2i] = []
	for i in range(difficulty):
		var enemy_tile = Vector2i(randi_range(0, x_tiles), randi_range(0, y_tiles))
		while obstacles.any(func(o): return o.has_point(enemy_tile)) || room_borders.any(func(b): return b.has_point(enemy_tile)) || enemy_tiles.find(enemy_tile) != -1:
			enemy_tile = Vector2i(randi_range(0, x_tiles), randi_range(0, y_tiles))
		enemy_tiles.append(enemy_tile)
		var enemy = enemies[randi() % enemies.size()].instantiate()
		enemy.name += str(i)
		enemy.position = enemy_tile * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
		room.add_child(enemy)
		if enemy.has_method("set_target"):
			enemy.call_deferred("set_target", player)
	
	# Place Keys
	print("Placing Keys")
	for key_tile in key_tiles:
		var key = load("res://scenes/items/key_light.tscn").instantiate()
		key.position = key_tile * tile_map.tile_set.tile_size + tile_map.tile_set.tile_size / 2
		print ("Key Tile: ", key_tile, "Key Position: ", key.position)
		room.add_child(key)

	# Add pause menu
	print("Adding Pause Menu")
	var pause_menu = load("res://scenes/menus/pause_menu.tscn").instantiate()
	room.add_child(pause_menu)

	return room

func get_obstacle_rect(position: Vector2, half_pattern_size: Vector2) -> Rect2i:
	var obstacle = Rect2i(floor(position - half_pattern_size), half_pattern_size * 2)
	
	# Make sure the obstacle is within the room
	if obstacle.position.x < 0:
		obstacle.position.x = abs(obstacle.position.x)
		obstacle.size.x += obstacle.position.x * 2
	
	if obstacle.position.y < 0:
		obstacle.position.y = abs(obstacle.position.y)
		obstacle.size.y += obstacle.position.y * 2

	return obstacle
