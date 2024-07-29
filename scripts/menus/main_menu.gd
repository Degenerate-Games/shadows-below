extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	var mode_select = load("res://scenes/menus/mode_select.tscn").instantiate()
	add_child(mode_select)


func _on_options_button_pressed():
	var options = load("res://scenes/menus/options.tscn").instantiate()
	add_child(options)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.seek(0)
	$AudioStreamPlayer._set_playing(true)
