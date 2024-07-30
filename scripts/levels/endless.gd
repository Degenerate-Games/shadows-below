extends Node2D

var difficulty: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_first_node_in_group("player")
	var hud = get_tree().get_first_node_in_group("HUD")
	hud.get_node("ColorMixingUI").color_changed.connect(player._on_color_mixing_ui_color_changed)
	player.handle_color_change(hud.get_node("ColorMixingUI").get_color())
	player.shadow_collected.connect(hud.get_node("ColorMixingUI")._on_shadow_collected)
	add_child(generate_room())

func _process(_delta):
	if Input.is_action_just_pressed("reload"):
		var room = get_child( - 1)
		if room.name.begins_with("Generated Room"):
			room.queue_free()
			add_child(LevelGenerator.generate_room(5))
	if Input.is_action_just_pressed("bake"):
		get_tree().call_group("navigation_region", "bake_navigation_polygon")

func generate_room() -> Node2D:
	var room = LevelGenerator.generate_room(difficulty)
	difficulty += 1
	return room

func set_aura_pulse_level(level: int):
	return
	var song_position = $AudioLayers/CombatPads.get_playback_position()
	match level:
		0:
			$AudioLayers/CombatDrums.stop()
			$AudioLayers/CombatSubBass.stop()
			$AudioLayers/CombatLead.stop()
			if not $AudioLayers/CombatPads.is_playing():
				$AudioLayers/CombatPads.play(0)
		1:
			$AudioLayers/CombatSubBass.stop()
			$AudioLayers/CombatLead.stop()
			if not $AudioLayers/CombatDrums.is_playing():
				$AudioLayers/CombatDrums.play(song_position)
		2:
			$AudioLayers/CombatLead.stop()
			if not $AudioLayers/CombatDrums.is_playing():
				$AudioLayers/CombatDrums.play(song_position)
			if not $AudioLayers/CombatSubBass.is_playing():
				$AudioLayers/CombatSubBass.play(song_position)
		3:
			if not $AudioLayers/CombatDrums.is_playing():
				$AudioLayers/CombatDrums.play(song_position)
			if not $AudioLayers/CombatSubBass.is_playing():
				$AudioLayers/CombatSubBass.play(song_position)
			if not $AudioLayers/CombatLead.is_playing():
				$AudioLayers/CombatLead.play(song_position)

func _on_combat_pads_finished():
	$AudioLayers/CombatPads.play(0)

func _on_combat_drums_finished():
	$AudioLayers/CombatDrums.play(0)

func _on_combat_lead_finished():
	$AudioLayers/CombatLead.play(0)

func _on_combat_sub_bass_finished():
	$AudioLayers/CombatSubBass.play(0)

func _on_combat_full_finished():
	$AudioLayer/CombatFull.play(0)
