extends Node2D

var score: int = 0

func add_score(amount: int) -> void:
	score += amount
	$"hud/score-tracker".text = 'Score: ' + str(score)
	
	if score >= 7:
		$"Level-transition-timer".startTransition(preload('res://scenes/level_2.tscn'))
