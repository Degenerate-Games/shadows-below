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
