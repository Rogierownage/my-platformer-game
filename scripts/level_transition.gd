extends Node

var levelPath;

func startTransition(level) -> void: 
	self.levelPath = level
	GlobalVariables.paused = true
	
	get_node("../Player").animation.play('spin')
		
	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished() -> void:
	get_parent().get_tree().change_scene_to_file(levelPath)
	
	GlobalVariables.paused = false;
