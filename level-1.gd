extends Node2D

var score = 0

func add_score(amount: int) -> void:
	score += amount
	$"hud/score-tracker".text = 'Score: ' + str(score)
	
	if score >= 7: get_tree().change_scene_to_file("res://level-2.tscn")
