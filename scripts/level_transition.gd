extends Node

var scene: PackedScene;

func startTransition(scene: PackedScene) -> void: 
	self.scene = scene
	
	var player: Player = get_tree().get_nodes_in_group('player')[0]
	
	player.set_physics_process(false)
	player.animation.play('level-transition')

	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished() -> void:
	get_parent().get_tree().change_scene_to_packed(scene)
