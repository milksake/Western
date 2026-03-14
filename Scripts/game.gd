extends Node2D

@onready var reload: Node2D = $Reload
@onready var aim: Area2D = $Aim
@onready var rhythm : Rhythm = $Rhythm

@export var enemies: Array[Area2D]

var score : int = 0
func _ready() -> void:
	for enemy in enemies:
		enemy.shots_player.connect(damage_player)
	pass

func damage_player():
	print("Player has been damaged")
	score -= 100
	$Label.text = str("Score: ", score)
	shake_camera()

func _process(delta: float) -> void:
	
	pass

func shake_camera():
	var tween = create_tween()
	tween.tween_property($Camera2D, "offset", Vector2(randf_range(-20,20), randf_range(-20,20)), 0.05)
	tween.tween_property($Camera2D, "offset", Vector2.ZERO, 0.05)

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

func _on_rhythm_beat() -> void:
	reload.beat_sprite()
	for enemy in enemies:
		enemy.beat()
	pass # Replace with function body.
