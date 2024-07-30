extends Node2D

var difficulty: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(generate_room())

func _process(_delta):
	if Input.is_action_just_pressed("reload"):
		var room = get_child(-1)
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
	var song_position = $AudioLayers/CombatPads.get_playback_position()
	match level:
		0:
			$AudioLayers/CombatDrums.stop()
			$AudioLayers/CombatBass.stop()
			$AudioLayers/CombatSub.stop()
			$AudioLayers/CombatLead.stop()
			if not $AudioLayers/CombatPads.is_playing():
				$AudioLayers/CombatPads.play()
		1:
			$AudioLayers/CombatBass.stop()
			$AudioLayers/CombatSub.stop()
			$AudioLayers/CombatLead.stop()
			if not $AudioLayers/CombatDrums.is_playing():
				$AudioLayers/CombatDrums.seek(song_position)
				$AudioLayers/CombatDrums._set_playing(true)
		2:
			$AudioLayers/CombatSub.stop()
			$AudioLayers/CombatLead.stop()
			if not $AudioLayers/CombatDrums.is_playing():
				$AudioLayers/CombatDrums.seek(song_position)
				$AudioLayers/CombatDrums._set_playing(true)
			if not $AudioLayers/CombatBass.is_playing():
				$AudioLayers/CombatBass.seek(song_position)
				$AudioLayers/CombatBass._set_playing(true)
		3:
			$AudioLayers/CombatLead.stop()
			if not $AudioLayers/CombatDrums.is_playing():
				$AudioLayers/CombatDrums.seek(song_position)
				$AudioLayers/CombatDrums._set_playing(true)
			if not $AudioLayers/CombatBass.is_playing():
				$AudioLayers/CombatBass.seek(song_position)
				$AudioLayers/CombatBass._set_playing(true)
			if not $AudioLayers/CombatSub.is_playing():
				$AudioLayers/CombatSub.seek(song_position)
				$AudioLayers/CombatSub._set_playing(true)
		4:
			if not $AudioLayers/CombatDrums.is_playing():
				$AudioLayers/CombatDrums.seek(song_position)
				$AudioLayers/CombatDrums._set_playing(true)
			if not $AudioLayers/CombatBass.is_playing():
				$AudioLayers/CombatBass.seek(song_position)
				$AudioLayers/CombatBass._set_playing(true)
			if not $AudioLayers/CombatSub.is_playing():
				$AudioLayers/CombatSub.seek(song_position)
				$AudioLayers/CombatSub._set_playing(true)
			if not $AudioLayers/CombatLead.is_playing():
				$AudioLayers/CombatLead.seek(song_position)
				$AudioLayers/CombatLead._set_playing(true)

func _on_combat_pads_finished():
	$AudioLayers/CombatPads.seek(0)
	$AudioLayers/CombatPads.play()


func _on_combat_drums_finished():
	$AudioLayers/CombatDrums.seek(0)
	$AudioLayers/CombatDrums.play()


func _on_combat_bass_finished():
	$AudioLayers/CombatBass.seek(0)
	$AudioLayers/CombatBass.play()


func _on_combat_sub_finished():
	$AudioLayers/CombatSub.seek(0)
	$AudioLayers/CombatSub.play()


func _on_combat_lead_finished():
	$AudioLayers/CombatLead.seek(0)
	$AudioLayers/CombatLead.play()
