extends RigidBody2D

func _on_body_entered(body):
	if body.has_method("collect"):
		body.collect(self)
		queue_free()

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()