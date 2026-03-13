extends Node2D

@onready var reload: Node2D = $Reload
@onready var aim: Area2D = $Aim
@onready var rhythm : Rhythm = $Rhythm

var score : int = 0
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_reload_left_action(state: int) -> void:
	var x = rhythm.tryBeat()
	if x > 0:
		if state > -1:
			print("Great" if x == 2 else "Ok")
			reload.dispose(state)
			var overlapping_areas = aim.get_overlapping_areas()
			if overlapping_areas and overlapping_areas[0].has_method("take_damage"):
				overlapping_areas[0].take_damage(20 if x == 2 else 10)
		else:
			print("No bullet")
	else:
		print("Out of Beat")

func _on_reload_right_action(state: int) -> void:
	var x = rhythm.tryBeat()
	if x > 0:
		if state < 0:
			print("Great" if x == 2 else "Ok")
			reload.reload(state)
		else:
			print("Bullet Already")
	else:
		print("Out of Beat")

func _on_enemy_is_shot(points: Variant) -> void:
	score += points
	$Label.text = str("Score: ", score)
	pass # Replace with function body.
