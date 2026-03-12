extends Node2D

@onready var reload: Node2D = $Reload
@onready var aim: Area2D = $Aim

var score : int = 0
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func _on_reload_left_action(state: int) -> void:
	if state > -1:
		var overlapping_areas = aim.get_overlapping_areas()
		if overlapping_areas and overlapping_areas[0].has_method("take_damage"):
			overlapping_areas[0].take_damage()
	else:
		print("No bullet")

func _on_enemy_is_shot(points: Variant) -> void:
	score += points
	$Label.text = str("Score: ", score)
	pass # Replace with function body.
