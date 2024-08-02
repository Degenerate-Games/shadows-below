extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StoryButton.grab_focus()

func _on_story_button_pressed():
	pass # Story Mode not Enabled


func _on_endless_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/endless.tscn")


func _on_sprite_test_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/sprite_test.tscn")

func _on_back_button_pressed():
	get_parent().get_node("VBoxContainer").get_node("StartButton").grab_focus()
	queue_free()

