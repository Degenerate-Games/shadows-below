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

extends RigidBody2D

@export var collectible_type: Global.COLLECTIBLE_TYPE = Global.COLLECTIBLE_TYPE.HEALTH

func _ready():
	contact_monitor = true
	max_contacts_reported = 5

func _on_body_entered(body):
	if body.has_method("collect"):
		body.collect(self)
		queue_free()

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()