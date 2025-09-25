extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		var parent = get_parent()
		
		parent.add_score(1)
		SoundCollectible.play()
		
		queue_free()
