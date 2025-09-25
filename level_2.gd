extends Node2D

var score = 0

func add_score(amount: int) -> void:
	#TODO: Extract score logic
	score += amount
	$"hud/score-tracker".text = 'Score: ' + str(score)
